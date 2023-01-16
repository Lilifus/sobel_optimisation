_cqa_text_report = {
  paths = {
    {
      hint = {
        {
          details = "Calling (and then returning from) a function prevents many compiler optimizations (like vectorization), breaks control flow (which reduces pipeline performance) and executes extra instructions to save/restore the registers used inside it, which is very expensive (dozens of cycles). Consider to inline small functions.\n - convolve_baseline: 2 occurrences\n",
          title = "CALL instructions",
          txt = "Detected function call instructions.\n",
        },
        {
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - JMP: 1 occurrences\n - VCOMISS: 1 occurrences\n - VCVTSI2SD: 1 occurrences\n - VCVTTSS2SI: 1 occurrences\n - VUCOMISD: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. Use double instead of single precision only when/where needed by numerical stability and avoid mixing precision.",
          details = " - VCVTSD2SS (FP64 to FP32, scalar): 1 occurrences\n - VCVTSI2SD (INT32/64 to FP64, scalar): 1 occurrences\n - VCVTTSS2SI (FP32 to INT32/64, scalar): 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions.",
        },
        {
          title = "Type of elements and instruction set",
          txt = "1 SSE or AVX instructions are processing arithmetic or math operations on single precision FP elements in scalar mode (one at a time).\n2 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop is composed of 1 FP arithmetical operations:\n - 1: square root\nThe binary loop is loading 4 bytes (0 double precision FP elements).\nThe binary loop is storing 1 bytes (0 double precision FP elements).",
        },
        {
          title = "Arithmetic intensity",
          txt = "Arithmetic intensity is 0.20 FP operations per loaded or stored byte.",
        },
      },
      expert = {
        {
          title = "General properties",
          txt = "nb instructions    : 31\nnb uops            : 48\nloop length        : 120\nused x86 registers : 12\nused mmx registers : 0\nused xmm registers : 3\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 2\n",
        },
        {
          title = "Front-end",
          txt = "MACRO FUSION NOT POSSIBLE\nFIT IN UOP CACHE\nmicro-operation queue: 8.00 cycles\nfront end            : 8.00 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3\n----------------------------------------------------------------------------\nuops   | 6.25 | 6.25 | 6.25 | 6.25 | 2.00 | 2.00 | 1.00 | 1.00 | 2.00 | 4.00\ncycles | 6.25 | 6.25 | 6.25 | 6.25 | 2.00 | 2.00 | 1.00 | 1.00 | 2.00 | 4.00\n\nCycles executing div or sqrt instructions: 4.00-8.00\nCycles loading/storing data              : 1.00\nLongest recurrence chain latency (RecMII): 1.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 8.00\nDispatch  : 6.25\nDIV/SQRT  : 4.00-8.00\nData deps.: 1.00\nOverall L1: 8.00\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 0%\nFP\nall     : 28%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 0%\nother   : 33%\nINT+FP\nall     : 12%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 0%\nother   : 13%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 18%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 18%\nFP\nall     : 28%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 25%\nother   : 29%\nINT+FP\nall     : 22%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 25%\nother   : 22%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 8.00 cycles. At this rate:\n - 1% of peak load performance is reached (0.50 out of 32.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 0% of peak store performance is reached (0.13 out of 16.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Performance is limited by instruction throughput (loading/decoding program instructions to execution core) (front-end is a bottleneck).\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 8.00 to 6.25 cycles (1.28x speedup).\n",
        },
        {
          title = "ASM code",
          txt = "In the binary file, the address of the loop is: 1398\n\nInstruction                    | Nb FU | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2 | FP3 | Latency | Recip. throughput\n----------------------------------------------------------------------------------------------------------------------------------------\nMOV %AL,(%R14,%RBP,1)          | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 4       | 1\nINC %RBP                       | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nCMP $0xefd,%RBP                | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nJE 1400 <sobel_baseline+0x151> | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nLEA (%RBP,%R13,1),%R12\nMOV $0x3,%ECX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV $0x3,%EDX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV %R15,%RSI                  | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nMOV %R12,%RDI                  | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nCALL 125b <convolve_baseline>  | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nMOV %EAX,%EBX                  | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nLEA 0x40(%RSP),%RSI\nMOV $0x3,%ECX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV $0x3,%EDX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV %R12,%RDI                  | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nCALL 125b <convolve_baseline>  | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nIMUL %EBX,%EBX                 | 1     | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 3       | 1\nIMUL %EAX,%EAX                 | 1     | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 3       | 1\nADD %EAX,%EBX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nVXORPD %XMM2,%XMM2,%XMM2       | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nVCVTSI2SD %EBX,%XMM2,%XMM0     | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 7       | 1\nVXORPD %XMM1,%XMM1,%XMM1       | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nVUCOMISD %XMM0,%XMM1           | 2     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 1   | 0   | 2       | 1\nJA 1381 <sobel_baseline+0xd2>  | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nVSQRTSD %XMM0,%XMM0,%XMM0      | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 8-20    | 4-8\nVCVTSD2SS %XMM0,%XMM0,%XMM0    | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 4       | 1\nMOV $-0x1,%EAX                 | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nVCOMISS 0x4(%RSP),%XMM0        | 2     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0.50 | 0.50 | 1   | 0   | 2       | 1\nJA 1388 <sobel_baseline+0xd9>  | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nVCVTTSS2SI %XMM0,%EAX          | 2     | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 8       | 1\nJMP 1388 <sobel_baseline+0xd9> | 6     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 2\n",
        },
      },
      header = {
        "Warnings:\n - The number of fused uops of the instruction [LEA	(%RBP,%R13,1),%R12] is unknown\n - The number of fused uops of the instruction [LEA	0x40(%RSP),%RSI] is unknown\n - Detected a function call instruction: ignoring called function instructions.\nRerun with --follow-calls=append to include them to analysis  or with --follow-calls=inline to simulate inlining.\n",
        "0% of peak computational performance is used (0.13 out of 24.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA)\n",
          details = "Store and arithmetical SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is probably not vectorized.\nOnly 22% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 8.00 to 4.00 cycles (2.00x speedup).",
        },
        {
          workaround = " - Reduce the number of division or square root instructions:\n  * If denominator is constant over iterations, use reciprocal (replace x/y with x*(1/y)). Check precision impact. This will be done by your compiler with ffast-math or Ofast\n - Check whether you really need double precision. If not, switch to single precision to speedup execution\n",
          title = "Execution units bottlenecks",
          txt = "Performance is limited by execution of divide and square root operations (the divide/square root unit is a bottleneck).\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 8.00 to 6.25 cycles (1.28x speedup).\n",
        },
      },
      potential = {
      },
    },
    {
      hint = {
        {
          details = "Calling (and then returning from) a function prevents many compiler optimizations (like vectorization), breaks control flow (which reduces pipeline performance) and executes extra instructions to save/restore the registers used inside it, which is very expensive (dozens of cycles). Consider to inline small functions.\n - convolve_baseline: 2 occurrences\n",
          title = "CALL instructions",
          txt = "Detected function call instructions.\n",
        },
        {
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - VCOMISS: 1 occurrences\n - VCVTSI2SD: 1 occurrences\n - VUCOMISD: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. Use double instead of single precision only when/where needed by numerical stability and avoid mixing precision.",
          details = " - VCVTSD2SS (FP64 to FP32, scalar): 1 occurrences\n - VCVTSI2SD (INT32/64 to FP64, scalar): 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions.",
        },
        {
          title = "Type of elements and instruction set",
          txt = "1 SSE or AVX instructions are processing arithmetic or math operations on single precision FP elements in scalar mode (one at a time).\n2 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop is composed of 1 FP arithmetical operations:\n - 1: square root\nThe binary loop is loading 4 bytes (0 double precision FP elements).\nThe binary loop is storing 1 bytes (0 double precision FP elements).",
        },
        {
          title = "Arithmetic intensity",
          txt = "Arithmetic intensity is 0.20 FP operations per loaded or stored byte.",
        },
      },
      expert = {
        {
          title = "General properties",
          txt = "nb instructions    : 29\nnb uops            : 40\nloop length        : 114\nused x86 registers : 12\nused mmx registers : 0\nused xmm registers : 3\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 2\n",
        },
        {
          title = "Front-end",
          txt = "MACRO FUSION NOT POSSIBLE\nFIT IN UOP CACHE\nmicro-operation queue: 6.67 cycles\nfront end            : 6.67 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3\n----------------------------------------------------------------------------\nuops   | 6.00 | 6.00 | 6.00 | 6.00 | 2.00 | 2.00 | 1.00 | 1.00 | 2.00 | 3.00\ncycles | 6.00 | 6.00 | 6.00 | 6.00 | 2.00 | 2.00 | 1.00 | 1.00 | 2.00 | 3.00\n\nCycles executing div or sqrt instructions: 4.00-8.00\nCycles loading/storing data              : 1.00\nLongest recurrence chain latency (RecMII): 1.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 6.67\nDispatch  : 6.00\nDIV/SQRT  : 4.00-8.00\nData deps.: 1.00\nOverall L1: 6.67-8.00\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 0%\nFP\nall     : 33%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 0%\nother   : 40%\nINT+FP\nall     : 13%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 0%\nother   : 14%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 18%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 18%\nFP\nall     : 31%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 25%\nother   : 32%\nINT+FP\nall     : 23%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 25%\nother   : 23%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 8.00 cycles. At this rate:\n - 1% of peak load performance is reached (0.50 out of 32.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 0% of peak store performance is reached (0.13 out of 16.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Found no such bottlenecks.",
        },
        {
          title = "ASM code",
          txt = "In the binary file, the address of the loop is: 1398\n\nInstruction                    | Nb FU | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2 | FP3 | Latency | Recip. throughput\n----------------------------------------------------------------------------------------------------------------------------------------\nMOV %AL,(%R14,%RBP,1)          | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 4       | 1\nINC %RBP                       | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nCMP $0xefd,%RBP                | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nJE 1400 <sobel_baseline+0x151> | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nLEA (%RBP,%R13,1),%R12\nMOV $0x3,%ECX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV $0x3,%EDX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV %R15,%RSI                  | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nMOV %R12,%RDI                  | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nCALL 125b <convolve_baseline>  | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nMOV %EAX,%EBX                  | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nLEA 0x40(%RSP),%RSI\nMOV $0x3,%ECX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV $0x3,%EDX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV %R12,%RDI                  | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nCALL 125b <convolve_baseline>  | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nIMUL %EBX,%EBX                 | 1     | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 3       | 1\nIMUL %EAX,%EAX                 | 1     | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 3       | 1\nADD %EAX,%EBX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nVXORPD %XMM2,%XMM2,%XMM2       | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nVCVTSI2SD %EBX,%XMM2,%XMM0     | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 7       | 1\nVXORPD %XMM1,%XMM1,%XMM1       | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nVUCOMISD %XMM0,%XMM1           | 2     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 1   | 0   | 2       | 1\nJA 1381 <sobel_baseline+0xd2>  | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nVSQRTSD %XMM0,%XMM0,%XMM0      | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 8-20    | 4-8\nVCVTSD2SS %XMM0,%XMM0,%XMM0    | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 4       | 1\nMOV $-0x1,%EAX                 | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nVCOMISS 0x4(%RSP),%XMM0        | 2     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0.50 | 0.50 | 1   | 0   | 2       | 1\nJA 1388 <sobel_baseline+0xd9>  | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\n",
        },
      },
      header = {
        "Warnings:\n - The number of fused uops of the instruction [LEA	(%RBP,%R13,1),%R12] is unknown\n - The number of fused uops of the instruction [LEA	0x40(%RSP),%RSI] is unknown\n - Detected a function call instruction: ignoring called function instructions.\nRerun with --follow-calls=append to include them to analysis  or with --follow-calls=inline to simulate inlining.\n",
        "0% of peak computational performance is used (0.13 out of 24.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA)\n",
          details = "Store and arithmetical SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is probably not vectorized.\nOnly 23% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 8.00 to 4.00 cycles (2.00x speedup).",
        },
        {
          workaround = " - Reduce the number of division or square root instructions:\n  * If denominator is constant over iterations, use reciprocal (replace x/y with x*(1/y)). Check precision impact. This will be done by your compiler with ffast-math or Ofast\n - Check whether you really need double precision. If not, switch to single precision to speedup execution\n",
          title = "Execution units bottlenecks",
          txt = "Performance is limited by execution of divide and square root operations (the divide/square root unit is a bottleneck).\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 8.00 to 6.67 cycles (1.20x speedup).\n",
        },
      },
      potential = {
        {
          title = "Expensive FP math instructions/calls",
          txt = "Detected performance impact from expensive FP math instructions/calls.\nBy removing/reexpressing them, you can lower the cost of an iteration from 8.00 to 6.67 cycles (1.20x speedup).",
        },
      },
    },
    {
      hint = {
        {
          details = "Calling (and then returning from) a function prevents many compiler optimizations (like vectorization), breaks control flow (which reduces pipeline performance) and executes extra instructions to save/restore the registers used inside it, which is very expensive (dozens of cycles). Consider to inline small functions.\n - convolve_baseline: 2 occurrences\n - sqrt@plt: 1 occurrences\n",
          title = "CALL instructions",
          txt = "Detected function call instructions.\n",
        },
        {
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - JMP: 2 occurrences\n - VCOMISS: 1 occurrences\n - VCVTSI2SD: 1 occurrences\n - VCVTTSS2SI: 1 occurrences\n - VUCOMISD: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. Use double instead of single precision only when/where needed by numerical stability and avoid mixing precision.",
          details = " - VCVTSD2SS (FP64 to FP32, scalar): 1 occurrences\n - VCVTSI2SD (INT32/64 to FP64, scalar): 1 occurrences\n - VCVTTSS2SI (FP32 to INT32/64, scalar): 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions.",
        },
        {
          title = "Type of elements and instruction set",
          txt = "1 SSE or AVX instructions are processing arithmetic or math operations on single precision FP elements in scalar mode (one at a time).\n1 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop does not contain any FP arithmetical operations.\nThe binary loop is loading 4 bytes (1 single precision FP elements).\nThe binary loop is storing 1 bytes (0 single precision FP elements).",
        },
      },
      expert = {
        {
          title = "General properties",
          txt = "nb instructions    : 32\nnb uops            : 59\nloop length        : 123\nused x86 registers : 12\nused mmx registers : 0\nused xmm registers : 3\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 2\n",
        },
        {
          title = "Front-end",
          txt = "MACRO FUSION NOT POSSIBLE\nFIT IN UOP CACHE\nmicro-operation queue: 9.83 cycles\nfront end            : 9.83 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3\n----------------------------------------------------------------------------\nuops   | 7.50 | 7.50 | 7.50 | 7.50 | 2.50 | 2.50 | 1.00 | 1.00 | 2.00 | 3.00\ncycles | 7.50 | 7.50 | 7.50 | 7.50 | 2.50 | 2.50 | 1.00 | 1.00 | 2.00 | 3.00\n\nCycles executing div or sqrt instructions: NA\nCycles loading/storing data              : 1.00\nLongest recurrence chain latency (RecMII): 1.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 9.83\nDispatch  : 7.50\nData deps.: 1.00\nOverall L1: 9.83\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 0%\nFP\nall     : 33%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 33%\nINT+FP\nall     : 13%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 13%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 18%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 18%\nFP\nall     : 29%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 29%\nINT+FP\nall     : 22%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 22%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 9.83 cycles. At this rate:\n - 1% of peak load performance is reached (0.41 out of 32.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 0% of peak store performance is reached (0.10 out of 16.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Performance is limited by instruction throughput (loading/decoding program instructions to execution core) (front-end is a bottleneck).\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 9.83 to 7.50 cycles (1.31x speedup).\n",
        },
        {
          title = "ASM code",
          txt = "In the binary file, the address of the loop is: 1398\n\nInstruction                     | Nb FU | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2 | FP3 | Latency | Recip. throughput\n-----------------------------------------------------------------------------------------------------------------------------------------\nCALL 10d0 <sqrt@plt>            | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nJMP 13e9 <sobel_baseline+0x13a> | 6     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 2\nMOV %AL,(%R14,%RBP,1)           | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 4       | 1\nINC %RBP                        | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nCMP $0xefd,%RBP                 | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nJE 1400 <sobel_baseline+0x151>  | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nLEA (%RBP,%R13,1),%R12\nMOV $0x3,%ECX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV $0x3,%EDX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV %R15,%RSI                   | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nMOV %R12,%RDI                   | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nCALL 125b <convolve_baseline>   | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nMOV %EAX,%EBX                   | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nLEA 0x40(%RSP),%RSI\nMOV $0x3,%ECX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV $0x3,%EDX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV %R12,%RDI                   | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nCALL 125b <convolve_baseline>   | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nIMUL %EBX,%EBX                  | 1     | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 3       | 1\nIMUL %EAX,%EAX                  | 1     | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 3       | 1\nADD %EAX,%EBX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nVXORPD %XMM2,%XMM2,%XMM2        | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nVCVTSI2SD %EBX,%XMM2,%XMM0      | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 7       | 1\nVXORPD %XMM1,%XMM1,%XMM1        | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nVUCOMISD %XMM0,%XMM1            | 2     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 1   | 0   | 2       | 1\nJA 1381 <sobel_baseline+0xd2>   | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nVCVTSD2SS %XMM0,%XMM0,%XMM0     | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 4       | 1\nMOV $-0x1,%EAX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nVCOMISS 0x4(%RSP),%XMM0         | 2     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0.50 | 0.50 | 1   | 0   | 2       | 1\nJA 1388 <sobel_baseline+0xd9>   | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nVCVTTSS2SI %XMM0,%EAX           | 2     | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 8       | 1\nJMP 1388 <sobel_baseline+0xd9>  | 6     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 2\n",
        },
      },
      header = {
        "Warnings:\n - The number of fused uops of the instruction [LEA	(%RBP,%R13,1),%R12] is unknown\n - The number of fused uops of the instruction [LEA	0x40(%RSP),%RSI] is unknown\n - Detected a function call instruction: ignoring called function instructions.\nRerun with --follow-calls=append to include them to analysis  or with --follow-calls=inline to simulate inlining.\n",
        "0% of peak computational performance is used (0.00 out of 48.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try to reorganize arrays of structures to structures of arrays\n - Consider to permute loops (see vectorization gain report)\n",
          title = "Code clean check",
          txt = "Detected a slowdown caused by scalar integer instructions (typically used for address computation).\nBy removing them, you can lower the cost of an iteration from 9.83 to 3.17 cycles (3.11x speedup).",
        },
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA)\n",
          details = "Store and arithmetical SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is probably not vectorized.\nOnly 22% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 9.83 to 1.34 cycles (7.31x speedup).",
        },
        {
          title = "Execution units bottlenecks",
          txt = "Found no such bottlenecks but see expert reports for more complex bottlenecks.",
        },
      },
      potential = {
      },
    },
    {
      hint = {
        {
          details = "Calling (and then returning from) a function prevents many compiler optimizations (like vectorization), breaks control flow (which reduces pipeline performance) and executes extra instructions to save/restore the registers used inside it, which is very expensive (dozens of cycles). Consider to inline small functions.\n - convolve_baseline: 2 occurrences\n - sqrt@plt: 1 occurrences\n",
          title = "CALL instructions",
          txt = "Detected function call instructions.\n",
        },
        {
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - JMP: 1 occurrences\n - VCOMISS: 1 occurrences\n - VCVTSI2SD: 1 occurrences\n - VUCOMISD: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. Use double instead of single precision only when/where needed by numerical stability and avoid mixing precision.",
          details = " - VCVTSD2SS (FP64 to FP32, scalar): 1 occurrences\n - VCVTSI2SD (INT32/64 to FP64, scalar): 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions.",
        },
        {
          title = "Type of elements and instruction set",
          txt = "1 SSE or AVX instructions are processing arithmetic or math operations on single precision FP elements in scalar mode (one at a time).\n1 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop does not contain any FP arithmetical operations.\nThe binary loop is loading 4 bytes (1 single precision FP elements).\nThe binary loop is storing 1 bytes (0 single precision FP elements).",
        },
      },
      expert = {
        {
          title = "General properties",
          txt = "nb instructions    : 30\nnb uops            : 51\nloop length        : 117\nused x86 registers : 12\nused mmx registers : 0\nused xmm registers : 3\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 2\n",
        },
        {
          title = "Front-end",
          txt = "MACRO FUSION NOT POSSIBLE\nFIT IN UOP CACHE\nmicro-operation queue: 8.50 cycles\nfront end            : 8.50 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3\n----------------------------------------------------------------------------\nuops   | 7.25 | 7.25 | 7.25 | 7.25 | 2.50 | 2.50 | 1.00 | 1.00 | 2.00 | 2.00\ncycles | 7.25 | 7.25 | 7.25 | 7.25 | 2.50 | 2.50 | 1.00 | 1.00 | 2.00 | 2.00\n\nCycles executing div or sqrt instructions: NA\nCycles loading/storing data              : 1.00\nLongest recurrence chain latency (RecMII): 1.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 8.50\nDispatch  : 7.25\nData deps.: 1.00\nOverall L1: 8.50\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 0%\nFP\nall     : 40%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 40%\nINT+FP\nall     : 14%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 14%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 18%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 18%\nFP\nall     : 32%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 32%\nINT+FP\nall     : 23%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 23%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 8.50 cycles. At this rate:\n - 1% of peak load performance is reached (0.47 out of 32.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 0% of peak store performance is reached (0.12 out of 16.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Performance is limited by instruction throughput (loading/decoding program instructions to execution core) (front-end is a bottleneck).\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 8.50 to 7.25 cycles (1.17x speedup).\n",
        },
        {
          title = "ASM code",
          txt = "In the binary file, the address of the loop is: 1398\n\nInstruction                     | Nb FU | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2 | FP3 | Latency | Recip. throughput\n-----------------------------------------------------------------------------------------------------------------------------------------\nCALL 10d0 <sqrt@plt>            | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nJMP 13e9 <sobel_baseline+0x13a> | 6     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 2\nMOV %AL,(%R14,%RBP,1)           | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 4       | 1\nINC %RBP                        | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nCMP $0xefd,%RBP                 | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nJE 1400 <sobel_baseline+0x151>  | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nLEA (%RBP,%R13,1),%R12\nMOV $0x3,%ECX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV $0x3,%EDX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV %R15,%RSI                   | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nMOV %R12,%RDI                   | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nCALL 125b <convolve_baseline>   | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nMOV %EAX,%EBX                   | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nLEA 0x40(%RSP),%RSI\nMOV $0x3,%ECX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV $0x3,%EDX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nMOV %R12,%RDI                   | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nCALL 125b <convolve_baseline>   | 6     | 1.25 | 1.25 | 1.25 | 1.25 | 0.50 | 0.50 | 0    | 0    | 0   | 0   | 0       | 1\nIMUL %EBX,%EBX                  | 1     | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 3       | 1\nIMUL %EAX,%EAX                  | 1     | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 3       | 1\nADD %EAX,%EBX                   | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nVXORPD %XMM2,%XMM2,%XMM2        | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nVCVTSI2SD %EBX,%XMM2,%XMM0      | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 7       | 1\nVXORPD %XMM1,%XMM1,%XMM1        | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 0   | 0       | 0.25\nVUCOMISD %XMM0,%XMM1            | 2     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 1   | 0   | 2       | 1\nJA 1381 <sobel_baseline+0xd2>   | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\nVCVTSD2SS %XMM0,%XMM0,%XMM0     | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0   | 1   | 4       | 1\nMOV $-0x1,%EAX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.25\nVCOMISS 0x4(%RSP),%XMM0         | 2     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0.50 | 0.50 | 1   | 0   | 2       | 1\nJA 1388 <sobel_baseline+0xd9>   | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0   | 0   | 1       | 0.50\n",
        },
      },
      header = {
        "Warnings:\n - The number of fused uops of the instruction [LEA	(%RBP,%R13,1),%R12] is unknown\n - The number of fused uops of the instruction [LEA	0x40(%RSP),%RSI] is unknown\n - Detected a function call instruction: ignoring called function instructions.\nRerun with --follow-calls=append to include them to analysis  or with --follow-calls=inline to simulate inlining.\n",
        "0% of peak computational performance is used (0.00 out of 48.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try to reorganize arrays of structures to structures of arrays\n - Consider to permute loops (see vectorization gain report)\n",
          title = "Code clean check",
          txt = "Detected a slowdown caused by scalar integer instructions (typically used for address computation).\nBy removing them, you can lower the cost of an iteration from 8.50 to 2.83 cycles (3.00x speedup).",
        },
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA)\n",
          details = "Store and arithmetical SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is probably not vectorized.\nOnly 23% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 8.50 to 1.17 cycles (7.27x speedup).",
        },
        {
          title = "Execution units bottlenecks",
          txt = "Found no such bottlenecks but see expert reports for more complex bottlenecks.",
        },
      },
      potential = {
      },
    },
  },
  AVG = {
      hint = {
        {
          details = "Calling (and then returning from) a function prevents many compiler optimizations (like vectorization), breaks control flow (which reduces pipeline performance) and executes extra instructions to save/restore the registers used inside it, which is very expensive (dozens of cycles). Consider to inline small functions.\n - convolve_baseline: 2 occurrences\n",
          title = "CALL instructions",
          txt = "Detected function call instructions.\n",
        },
        {
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - JMP: 1.33 occurrences\n - VCOMISS: 1 occurrences\n - VCVTSI2SD: 1 occurrences\n - VCVTTSS2SI: 1 occurrences\n - VUCOMISD: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. Use double instead of single precision only when/where needed by numerical stability and avoid mixing precision.",
          details = " - VCVTSD2SS (FP64 to FP32, scalar): 1 occurrences\n - VCVTSI2SD (INT32/64 to FP64, scalar): 1 occurrences\n - VCVTTSS2SI (FP32 to INT32/64, scalar): 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions.",
        },
        {
          title = "Type of elements and instruction set",
          txt = "1 SSE or AVX instructions are processing arithmetic or math operations on single precision FP elements in scalar mode (one at a time).\n1 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop is composed of 0.5 FP arithmetical operations:\n - 0.50: square root\nThe binary loop is loading 4 bytes (0 double precision FP elements).\nThe binary loop is storing 1 bytes (0 double precision FP elements).",
        },
        {
          title = "Arithmetic intensity",
          txt = "Arithmetic intensity is 0.10 FP operations per loaded or stored byte.",
        },
      },
      expert = {
        {
          title = "General properties",
          txt = "nb instructions    : 30.50\nnb uops            : 49.50\nloop length        : 118.50\nused x86 registers : 12\nused mmx registers : 0\nused xmm registers : 3\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 2\n",
        },
        {
          title = "Front-end",
          txt = "MACRO FUSION NOT POSSIBLE\nmicro-operation queue: 8.25 cycles\nfront end            : 8.25 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3\n----------------------------------------------------------------------------\nuops   | 6.75 | 6.75 | 6.75 | 6.75 | 2.25 | 2.25 | 1.00 | 1.00 | 2.00 | 3.00\ncycles | 6.75 | 6.75 | 6.75 | 6.75 | 2.25 | 2.25 | 1.00 | 1.00 | 2.00 | 3.00\n\nCycles executing div or sqrt instructions: 2.00-4.00\nLongest recurrence chain latency (RecMII): 1.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 8.25\nDispatch  : 6.75\nDIV/SQRT  : 2.00-4.00\nData deps.: 1.00\nOverall L1: 8.25-8.58\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 0%\nFP\nall     : 33%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 0%\nother   : 36%\nINT+FP\nall     : 13%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 0%\nother   : 13%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 18%\nload   : NA (no load vectorizable/vectorized instructions)\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 18%\nFP\nall     : 30%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 25%\nother   : 30%\nINT+FP\nall     : 22%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : NA (no mul vectorizable/vectorized instructions)\nadd-sub : NA (no add-sub vectorizable/vectorized instructions)\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: 25%\nother   : 22%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 8.58 cycles. At this rate:\n - 1% of peak load performance is reached (0.47 out of 32.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 0% of peak store performance is reached (0.12 out of 16.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
      },
      header = {
        "0% of peak computational performance is used (0.06 out of 24.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA)\n",
          details = "Store and arithmetical SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is probably not vectorized.\nOnly 22% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 8.58 to 2.63 cycles (3.27x speedup).",
        },
      },
      potential = {
      },
    },
  common = {
    header = {
      "The loop is defined in /home/zakaria/Desktop/Work/AP/sobel_optimisation/sobel.c:75-82.\n",
      "The related source loop is not unrolled or unrolled with no peel/tail loop.",
      "This loop has 4 execution paths.\n",
      "The presence of multiple execution paths is typically the main/first bottleneck.\nTry to simplify control inside loop: ideally, try to remove all conditional expressions, for example by (if applicable):\n - hoisting them (moving them outside the loop)\n - turning them into conditional moves, MIN or MAX\n\n",
    },
    nb_paths = 4,
  },
}
