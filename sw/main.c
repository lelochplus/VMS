#include <stdint.h>

#define UART_TX     (*(volatile uint32_t *)0x10000000)
#define UART_STATUS (*(volatile uint32_t *)0x10000004)

#define DMA_BASE    0x10004000u
#define DMA_CTRL    (*(volatile uint32_t *)(DMA_BASE + 0x00))
#define DMA_STATUS  (*(volatile uint32_t *)(DMA_BASE + 0x04))
#define DMA_SRC     (*(volatile uint32_t *)(DMA_BASE + 0x08))
#define DMA_DST     (*(volatile uint32_t *)(DMA_BASE + 0x0C))
#define DMA_LEN     (*(volatile uint32_t *)(DMA_BASE + 0x10))

#define DMA_START   (1u << 0)
#define DMA_SRC_INC (1u << 2)
#define DMA_DST_INC (1u << 3)
#define DMA_IRQ_EN  (1u << 1)
#define ST_BUSY     (1u << 0)
#define ST_DONE     (1u << 1)
#define ST_ERR      (1u << 2)

#define N 16
#ifndef PERF_N
#define PERF_N 256
#endif

static uint32_t src_buf[N];
static uint32_t dst_buf[N];
static uint32_t perf_src[PERF_N];
static uint32_t perf_dst[PERF_N];

volatile uint32_t irq_count;

// Được gọi từ vector ngắt trong start.S. irqs = bitmask các ngắt đang chờ.
void irq_handler(uint32_t irqs) {
    if (irqs & (1u << 3)) {              // ngắt của DMA
        DMA_STATUS = ST_DONE | ST_ERR;   // xóa cờ để hạ chân irq
        irq_count++;
    }
}

static void uart_putc(char c) {
    while (UART_STATUS & 1);          // chờ hết BUSY
    UART_TX = (uint32_t)c;
}

static void uart_puts(const char *s) {
    while (*s) uart_putc(*s++);
}

// In số thập phân không dùng phép chia (core chưa có tập lệnh M)
static void uart_putdec(uint32_t v) {
    static const uint32_t p10[10] = {
        1000000000u, 100000000u, 10000000u, 1000000u, 100000u,
        10000u, 1000u, 100u, 10u, 1u
    };
    int k, started = 0;
    for (k = 0; k < 10; k++) {
        char d = '0';
        while (v >= p10[k]) { v -= p10[k]; d++; }
        if (d != '0' || started || k == 9) { uart_putc(d); started = 1; }
    }
}

static inline uint32_t rdcycle(void) {
    uint32_t c;
    __asm__ volatile ("rdcycle %0" : "=r"(c));
    return c;
}

static __attribute__((noinline)) void cpu_copy(const uint32_t *s, uint32_t *d, uint32_t words) {
    while (words--) *d++ = *s++;
}

// Chép bằng DMA, chờ bằng cách đọc STATUS (polling). Trả về STATUS cuối.
static uint32_t dma_copy(const void *src, void *dst, uint32_t words) {
    uint32_t st;
    while (DMA_STATUS & ST_BUSY);
    DMA_SRC = (uint32_t)src;
    DMA_DST = (uint32_t)dst;
    DMA_LEN = words;
    DMA_CTRL = DMA_START | DMA_SRC_INC | DMA_DST_INC;
    do { st = DMA_STATUS; } while (st & ST_BUSY);
    DMA_STATUS = ST_DONE | ST_ERR;    // xóa cờ
    return st;
}

int main(void) {
    uint32_t i, st, bad = 0;

    uart_puts("Hello, RISC-V SoC!\n");

    for (i = 0; i < N; i++) {
        src_buf[i] = 0xA5A50000u | i;
        dst_buf[i] = 0;
    }

    st = dma_copy(src_buf, dst_buf, N);
    if (st != ST_DONE) bad++;
    for (i = 0; i < N; i++)
        if (dst_buf[i] != src_buf[i]) bad++;

    uart_puts(bad ? "DMA FAIL\n" : "DMA OK\n");

    // Test ngắt: DMA báo xong bằng irq, CPU chờ trong vòng lặp
    for (i = 0; i < N; i++) dst_buf[i] = 0;
    irq_count = 0;
    DMA_SRC = (uint32_t)src_buf;
    DMA_DST = (uint32_t)dst_buf;
    DMA_LEN = N;
    DMA_CTRL = DMA_START | DMA_SRC_INC | DMA_DST_INC | DMA_IRQ_EN;
    while (irq_count == 0);
    bad = (irq_count != 1);
    for (i = 0; i < N; i++)
        if (dst_buf[i] != src_buf[i]) bad++;
    uart_puts(bad ? "IRQ FAIL\n" : "IRQ OK\n");

    // Test đồng thời: DMA chép perf_src -> perf_dst (64 word) trong khi CPU tự chép src_buf -> dst_buf
    for (i = 0; i < 64; i++) { perf_src[i] = 0xC0DE0000u | i; perf_dst[i] = 0; }
    for (i = 0; i < N; i++) dst_buf[i] = 0;
    DMA_SRC = (uint32_t)perf_src;
    DMA_DST = (uint32_t)perf_dst;
    DMA_LEN = 64;
    DMA_CTRL = DMA_START | DMA_SRC_INC | DMA_DST_INC;
    cpu_copy(src_buf, dst_buf, N);              // CPU dùng bus cùng lúc với DMA
    do { st = DMA_STATUS; } while (st & ST_BUSY);
    DMA_STATUS = ST_DONE | ST_ERR;
    bad = (st != ST_DONE);
    for (i = 0; i < N; i++) if (dst_buf[i] != src_buf[i]) bad++;
    for (i = 0; i < 64; i++) if (perf_dst[i] != perf_src[i]) bad++;
    uart_puts(bad ? "CONC FAIL\n" : "CONC OK\n");

    // Đo hiệu năng: chép n word bằng CPU và bằng DMA (rdcycle, gồm cả cấu hình và chờ)
#if PERF_N >= 256
    static const uint32_t sizes[] = {16, 32, 64, 128, 256};
#else
    static const uint32_t sizes[] = {16, 32, 64, 128};
#endif
    uint32_t k, n, t0, t_cpu, t_dma;
    for (k = 0; k < sizeof sizes / sizeof sizes[0]; k++) {
        n = sizes[k];
        for (i = 0; i < n; i++) { perf_src[i] = 0x5A000000u | i; perf_dst[i] = 0; }
        t0 = rdcycle(); cpu_copy(perf_src, perf_dst, n); t_cpu = rdcycle() - t0;
        bad = 0;
        for (i = 0; i < n; i++) if (perf_dst[i] != perf_src[i]) bad++;
        for (i = 0; i < n; i++) perf_dst[i] = 0;
        t0 = rdcycle(); st = dma_copy(perf_src, perf_dst, n); t_dma = rdcycle() - t0;
        bad += (st != ST_DONE);
        for (i = 0; i < n; i++) if (perf_dst[i] != perf_src[i]) bad++;
        uart_puts("N="); uart_putdec(n);
        uart_puts(" CPU="); uart_putdec(t_cpu);
        uart_puts(" DMA="); uart_putdec(t_dma);
        uart_puts(bad ? " FAIL\n" : "\n");
    }
    uart_putc(4);                     // EOT: báo testbench kết thúc
    for (;;);
}
