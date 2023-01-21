/*
This code performs edge detection using a Sobel filter on a video stream meant as input to a neural network
*/
#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <emmintrin.h>
#include <smmintrin.h>

//
#include "common.h"

#define NUM_THREADS 8

struct thread_data {
    i32 start,end;
    u8* cframe, * oframe;
    f32 threshold;
};
//

//Convert an image to its grayscale equivalent - better color precision
void grayscale_weighted(u8 *frame)
{
    f32 gray;

    for (u64 i = 0; i < H * W * 3; i += 3)
    {
        //Convert RGB color values into grayscale for each pixel using color weights
        //Other possible weights: 0.59, 0.30, 0.11
        //Principle: mix different quantities of R, G, B to create a variant of gray
        gray = ((float)frame[i] * 0.299) + ((float)frame[i + 1] * 0.587) + ((float)frame[i + 2] * 0.114);

        frame[i]     = gray;
        frame[i + 1] = gray;
        frame[i + 2] = gray;
    }
}

//Convert an image to its grayscale equivalent - bad color precision
void grayscale_sampled(u8 *frame)
{
    for (u64 i = 0; i < H * W * 3; i += 3)
    {
        //R: light gray
        //G: medium gray
        //B: dark gray
        u8 gray = frame[i];

        frame[i]     = gray;
        frame[i + 1] = gray;
        frame[i + 2] = gray;
    }
}

//
i32 convolve_baseline(u8 *m, i32 *f, u64 fh, u64 fw)
{
    i32 r = 0;

    for (u64 i = 0; i < fh; i++){
        for (u64 j = 0; j < fw; j++)
            r += m[INDEX(i, j*3, W * 3)] * f[INDEX(i, j, fw)];
    }
    return r;
}

//
void sobel_baseline(u8 *cframe, u8 *oframe, f32 threshold)
{
    i32 gx, gy;
    f32 mag = 0.0;

    i32 f1[9] = { -1, 0, 1,
        -2, 0, 2,
        -1, 0, 1 }; //3x3 matrix

    i32 f2[9] = { -1, -2, -1,
        0, 0, 0,
        1, 2, 1 }; //3x3 matrix

    for (u64 i = 0; i < (H - 3); i++)
        for (u64 j = 0; j < ((W * 3) - 3); j++)
        {
            gx = convolve_baseline(&cframe[INDEX(i, j, W * 3)], f1, 3, 3);
            gy = convolve_baseline(&cframe[INDEX(i, j, W * 3)], f2, 3, 3);

            mag = sqrt((gx * gx) + (gy * gy));

            oframe[INDEX(i, j, W * 3)] = (mag > threshold) ? 255 : mag;
        }
}
//
i32 convolve_align(u8 * __restrict__ m, i32 * __restrict__ f, u64 fh, u64 fw)
{
    i32 r = 0;

    for (u64 i = 0; i < fh; i++){
        for (u64 j = 0; j < fw; j++)
            r += m[INDEX(i, j*3, W * 3)] * f[INDEX(i, j, fw)];
    }
    return r;
}

u8 *cframe __attribute__((aligned(64)));
u8 *oframe __attribute__((aligned(64)));
i32 *f1 __attribute__((aligned(64)));
i32 *f2 __attribute__((aligned(64)));
//
void sobel_align(u8 *cframe, u8 *oframe, f32 threshold)
{
    i32 gx, gy;
    f32 mag = 0.0;

    i32 f1[9] = { -1, 0, 1,
        -2, 0, 2,
        -1, 0, 1 }; //3x3 matrix

    i32 f2[9] = { -1, -2, -1,
        0, 0, 0,
        1, 2, 1 }; //3x3 matrix

    for (u64 i = 0; i < (H - 3); i++)
        for (u64 j = 0; j < ((W * 3) - 3); j++)
        {
            gx = convolve_baseline(__builtin_assume_aligned(cframe,64)+INDEX(i, j, W * 3), __builtin_assume_aligned(f1,64), 3, 3);
            gy = convolve_baseline(__builtin_assume_aligned(cframe,64)+INDEX(i, j, W * 3),  __builtin_assume_aligned(f2,64), 3, 3);

            mag = sqrt((gx * gx) + (gy * gy));

            oframe[INDEX(i, j, W * 3)] = (mag > threshold) ? 255 : mag;
        }
}
//
i32 convolve_unroll(u8 *m, i32 *f, u64 fh, u64 fw)
{
#define UNROLL 8
    i32 r = 0;

    for (u64 i = 0; i < fh; i++){
        for (u64 j = 0; j < (fw - (fw&(UNROLL-1))); j+=UNROLL){
            r += m[INDEX(i, j*3, W * 3)] * f[INDEX(i, j, fw)];
            r += m[INDEX(i, (j+1) *3, W * 3)] * f[INDEX(i, j+1, fw)];
            r += m[INDEX(i, (j+2) *3, W * 3)] * f[INDEX(i, j+2, fw)];
            r += m[INDEX(i, (j+3) *3, W * 3)] * f[INDEX(i, j+3, fw)];
            r += m[INDEX(i, (j+4) *3, W * 3)] * f[INDEX(i, j+4, fw)];
            r += m[INDEX(i, (j+5) *3, W * 3)] * f[INDEX(i, j+5, fw)];
            r += m[INDEX(i, (j+6) *3, W * 3)] * f[INDEX(i, j+6, fw)];
            r += m[INDEX(i, (j+7) *3, W * 3)] * f[INDEX(i, j+7, fw)];
        }
        for (u64 j = (fw - (fw&(UNROLL-1))); j < fw; j++)
            r += m[INDEX(i, j*3, W * 3)] * f[INDEX(i, j, fw)];
    }
    return r;
}

//
void sobel_unroll(u8 *cframe, u8 *oframe, f32 threshold)
{
    i32 gx, gy;
    f32 mag = 0.0;

    i32 f1[9] = { -1, 0, 1,
        -2, 0, 2,
        -1, 0, 1 }; //3x3 matrix

    i32 f2[9] = { -1, -2, -1,
        0, 0, 0,
        1, 2, 1 }; //3x3 matrix

    //
    for (u64 i = 0; i < (H - 3); i++)
        for (u64 j = 0; j < ((W * 3) - 3); j++)
        {
            gx = convolve_unroll(&cframe[INDEX(i, j, W * 3)], f1, 3, 3);
            gy = convolve_unroll(&cframe[INDEX(i, j, W * 3)], f2, 3, 3);

            mag = sqrt((gx * gx) + (gy * gy));

            oframe[INDEX(i, j, W * 3)] = (mag > threshold) ? 255 : mag;
        }
}

//
void sobel_sqrtless(u8 *cframe, u8 *oframe, f32 threshold)
{
    i32 gx, gy;
    f32 mag = 0.0;

    i32 f1[9] = { -1, 0, 1,
        -2, 0, 2,
        -1, 0, 1 }; //3x3 matrix

    i32 f2[9] = { -1, -2, -1,
        0, 0, 0,
        1, 2, 1 }; //3x3 matrix

    threshold *= threshold;
    //
    for (u64 i = 0; i < (H - 3); i++)
        for (u64 j = 0; j < ((W * 3) - 3); j++)
        {
            gx = convolve_baseline(&cframe[INDEX(i, j, W * 3)], f1, 3, 3);
            gy = convolve_baseline(&cframe[INDEX(i, j, W * 3)], f2, 3, 3);

            mag = gx*gx + gy*gy;

            oframe[INDEX(i, j, W * 3)] = (mag > threshold) ? 255 : 0;
        }
}
i32 convolve_sse(u8 * __restrict__ m, i32 * __restrict__ f, u64 fh, u64 fw)
{
    __m128i m_vec, f_vec, r_vec, temp_vec;
    r_vec = _mm_setzero_si128();
    int r[4];

    for (u64 i = 0; i < fh; i++)
    {
        for (u64 j = 0; j < fw; j+=3)
        {
            // Load 3 elements of image matrix at a time and convert them into 32-bit signed integers
            m_vec = _mm_set_epi32(0, m[INDEX(i, (j+2)*3, W * 3)], m[INDEX(i, (j+1)*3, W * 3)], m[INDEX(i, j*3, W * 3)]);
            // Load 3 elements of filter matrix at a time
            f_vec = _mm_set_epi32(0, f[INDEX(i, j+2, fw)], f[INDEX(i, j+1, fw)], f[INDEX(i, j, fw)]);
            // Perform the convolution by multiplying the 3 elements of image matrix with the 3 elements of filter matrix
            temp_vec = _mm_mullo_epi32(m_vec, f_vec);
            // Accumulate the results
            r_vec = _mm_add_epi32(r_vec, temp_vec);
        }
    }
    // Store the results in an i32 array
    _mm_storeu_si128((__m128i *) r, r_vec);
    // Add up the results
    return r[0] + r[1] + r[2] + r[3];
}

u8 *cframe __attribute__((aligned(64)));
i32 *f1 __attribute__((aligned(64)));
i32 *f2 __attribute__((aligned(64)));
void sobel_sse(u8 *cframe, u8 *oframe, f32 threshold)
{
    i32 gx, gy;
    f32 mag;

    i32 f1[9] = { -1, 0, 1,
        -2, 0, 2,
        -1, 0, 1 }; //3x3 matrix

    i32 f2[9] = { -1, -2, -1,
        0, 0, 0,
        1, 2, 1 }; //3x3 matrix

    // Create a __m128 variable to store the threshold value
    __m128 threshold_vec = _mm_set1_ps(threshold);
    __m128 mag_vec_float;
    __m128i mag_vec, ones_vec = _mm_set1_epi8((u8)255);

    // Iterate over the image
    for (u64 i = 0; i < (H - 3); i++)
    {
        for (u64 j = 0; j < ((W * 3) - 3); j+=4)
        {
            // call the convolve_baseline_sse function to calculate the gradient in the x and y directions
            gx = convolve_sse(&cframe[INDEX(i, j, W * 3)], f1, 3, 3);
            gy = convolve_sse(&cframe[INDEX(i, j, W * 3)], f2, 3, 3);

            // calculate the magnitude of the gradient
            mag = sqrt((gx * gx) + (gy * gy));
            mag_vec_float = _mm_set1_ps(mag);

            // compare the magnitude with threshold
            mag_vec = _mm_cvttps_epi32(_mm_cmpgt_ps(mag_vec_float , threshold_vec));

            // set the output pixel to 255 if the magnitude is greater than the threshold
            mag_vec = _mm_and_si128(mag_vec, ones_vec);
            // set the output pixel to the magnitude value if the magnitude is less than or equal to the threshold
            _mm_storeu_si128((__m128i *) &oframe[INDEX(i, j, W * 3)], _mm_or_si128(mag_vec, _mm_andnot_si128(mag_vec, _mm_set1_epi8((u8)mag))));
        }
    }
}
void *sobel_thread(void *thread_data)
{
    struct thread_data *data = (struct thread_data *)thread_data;

    i32 gx, gy;
    f32 mag = 0.0;

    i32 f1[9] = { -1, 0, 1,
        -2, 0, 2,
        -1, 0, 1 }; //3x3 matrix

    i32 f2[9] = { -1, -2, -1,
        0, 0, 0,
        1, 2, 1 }; //3x3 matrix

    for (u64 i = data->start; i < data->end; i++) {
        for (u64 j = 0; j < ((W * 3) - 3); j++) {
            gx = convolve_baseline(&data->cframe[INDEX(i, j, W * 3)], f1, 3, 3);
            gy = convolve_baseline(&data->cframe[INDEX(i, j, W * 3)], f2, 3, 3);

            mag = sqrt((gx * gx) + (gy * gy));

            data->oframe[INDEX(i, j, W * 3)] = (mag > data->threshold) ? 255 : mag;
        }
    }
    pthread_exit(NULL);
}
void sobel_pthread(u8 *cframe, u8 *oframe, f32 threshold)
{
    pthread_t threads[NUM_THREADS];
    struct thread_data data[NUM_THREADS];
    u64 block_size = (H - 3) / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].start = i * block_size;
        data[i].end = (i + 1) * block_size;
        data[i].cframe = cframe;
        data[i].oframe = oframe;
        data[i].threshold = threshold;
        pthread_create(&threads[i], NULL, sobel_thread, &data[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }
}

void *sobel_thread_all(void *thread_data)
{
    struct thread_data *data = (struct thread_data *)thread_data;

    i32 gx, gy;
    f32 mag = 0.0;

    i32 f1[9] = { -1, 0, 1,
        -2, 0, 2,
        -1, 0, 1 }; //3x3 matrix

    i32 f2[9] = { -1, -2, -1,
        0, 0, 0,
        1, 2, 1 }; //3x3 matrix
    data->threshold*=data->threshold;
    for (u64 i = data->start; i < data->end; i++) {
        for (u64 j = 0; j < ((W * 3) - 3); j++) {
            gx = convolve_baseline(&data->cframe[INDEX(i, j, W * 3)], f1, 3, 3);
            gy = convolve_baseline(&data->cframe[INDEX(i, j, W * 3)], f2, 3, 3);

            mag = (gx * gx) + (gy * gy);

            data->oframe[INDEX(i, j, W * 3)] = (mag > data->threshold) ? 255 : 0;
        }
    }
    pthread_exit(NULL);
}

void sobel_all(u8 *cframe, u8 *oframe, f32 threshold)
{
    pthread_t threads[NUM_THREADS];
    struct thread_data data[NUM_THREADS];
    u64 block_size = (H - 3) / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].start = i * block_size;
        data[i].end = (i + 1) * block_size;
        data[i].cframe = cframe;
        data[i].oframe = oframe;
        data[i].threshold = threshold;
        pthread_create(&threads[i], NULL, sobel_thread_all, &data[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }
}
//
int main(int argc, char **argv)
{
    f64 basetime = 46.0;
    //
    if (argc < 3)
        return printf("Usage: %s [raw input file] [raw output file]\n", argv[0]), 1;

    //Size of a frame
    u64 size = sizeof(u8) * H * W * 3;

    //
    f64 elapsed_s = 0.0;
    f64 elapsed_ns = 0.0;
    f64 mib_per_s = 0.0;
    struct timespec t1, t2;
    f64 samples[MAX_SAMPLES];
    //
    u64 nb_bytes = 1, frame_count = 0, samples_count = 0;

    //
    u8 *cframe = _mm_malloc(size, 32);
    u8 *oframe = _mm_malloc(size, 32);

    //
    FILE *fpi = fopen(argv[1], "rb"); 
    FILE *fpo = fopen(argv[2], "wb");

    //
    if (!fpi)
        return printf("Error: cannot open file '%s'\n", argv[1]), 2;

    //
    if (!fpo)
        return printf("Error: cannot open file '%s'\n", argv[2]), 2;

    //Read & process video frames
    while ((nb_bytes = fread(cframe, sizeof(u8), H * W * 3, fpi)))
    {
        //
        grayscale_weighted(cframe);

        do
        {

            //Start 
            clock_gettime(CLOCK_MONOTONIC_RAW, &t1);

            //Put other versions here

#if BASELINE
            sobel_baseline(cframe, oframe, 100.0);
#elif ALIGN
            sobel_align(cframe, oframe, 100.0);
#elif UNROLLED
            sobel_unroll(cframe,oframe,100.0);
#elif SQRTLESS
            sobel_sqrtless(cframe,oframe,100.0);
#elif THREADS
            sobel_pthread(cframe,oframe,100.0);
#elif SSE
            sobel_sse(cframe,oframe,100.0);
#elif ALL
            sobel_all(cframe,oframe,100.0);
#endif
            //Stop
            clock_gettime(CLOCK_MONOTONIC_RAW, &t2);

            //Nano seconds
            elapsed_ns = (f64)(t2.tv_nsec - t1.tv_nsec);

        }
        while (elapsed_ns <= 0.0);

        //Seconds
        elapsed_s = elapsed_ns / 1e9;

        //2 arrays
        mib_per_s = ((f64)(nb_bytes << 1) / (1024.0 * 1024.0)) / elapsed_s;

        //
        if (samples_count < MAX_SAMPLES)
            samples[samples_count++] = elapsed_ns;

        //frame number; size in Bytes; elapsed ns; elapsed s; bytes per second
        fprintf(stdout, "%20llu; %20llu bytes; %15.3lf ns; %15.3lf MiB/s\n", frame_count, nb_bytes << 1, elapsed_ns, mib_per_s);

        // Write this frame to the output pipe
        fwrite(oframe, sizeof(u8), H * W * 3, fpo);

        //
        frame_count++;
    }

    //
    sort(samples, samples_count);

    //
    f64 min, max, avg, mea, dev;

    //
    mea = mean(samples, samples_count);

    //
    dev = stddev(samples, samples_count);

    //
    min = samples[0];
    max = samples[samples_count - 1];

    /* elapsed_s = mea / 1e9; */
    elapsed_s = mea * 1e-9;

    //2 arrays (input & output)
    mib_per_s = ((f64)(size << 1) / (1024.0 * 1024.0)) / elapsed_s;

    //
    fprintf(stderr,"\n%20lu bytes; %15.3lf ns; %15.3lf ns; %15.3lf ns; %15.3lf MiB/s; %15.3lf %%; %15.3lf\n",
            (sizeof(u8) * H * W * 3) << 1,
            min,
            max,
            mea,
            mib_per_s,
            (dev * 100.0 / mea),
            mib_per_s/basetime);

    //
    _mm_free(cframe);
    _mm_free(oframe);

    //
    fclose(fpi);
    fclose(fpo);

    return  0;
}
