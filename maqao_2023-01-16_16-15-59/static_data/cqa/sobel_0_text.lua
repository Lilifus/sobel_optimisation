_cqa_text_report = {
  paths = {
    {
      hint = {
        {
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - VCVTSI2SD: 3 occurrences\n - VCVTTSS2SI: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. Use double instead of single precision only when/where needed by numerical stability and avoid mixing precision.",
          details = " - VCVTSD2SS (FP64 to FP32, scalar): 1 occurrences\n - VCVTSI2SD (INT32/64 to FP64, scalar): 3 occurrences\n - VCVTTSS2SI (FP32 to INT32/64, scalar): 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions.",
        },
        {
          title = "Type of elements and instruction set",
          txt = "5 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop is composed of 5 FP arithmetical operations:\n - 2: addition or subtraction\n - 3: multiply\nThe binary loop is loading 3 bytes (0 double precision FP elements).\nThe binary loop is storing 3 bytes (0 double precision FP elements).",
        },
        {
          title = "Arithmetic intensity",
          txt = "Arithmetic intensity is 0.83 FP operations per loaded or stored byte.",
        },
        {
          workaround = "Unroll your loop if trip count is significantly higher than target unroll factor and if some data references are common to consecutive iterations. This can be done manually. Or by recompiling with -funroll-loops and/or -floop-unroll-and-jam.",
          title = "Unroll opportunity",
          txt = "Loop is potentially data access bound.",
        },
      },
      expert = {
        {
          title = "General properties",
          txt = "nb instructions    : 19\nnb uops            : 22\nloop length        : 68\nused x86 registers : 3\nused mmx registers : 0\nused xmm registers : 6\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 0\nADD-SUB / MUL ratio: 0.67\n",
        },
        {
          title = "Front-end",
          txt = "ASSUMED MACRO FUSION\nFIT IN UOP CACHE\nmicro-operation queue: 3.67 cycles\nfront end            : 3.67 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3\n----------------------------------------------------------------------------\nuops   | 2.00 | 2.00 | 3.00 | 2.00 | 3.00 | 3.00 | 1.50 | 1.50 | 2.00 | 5.00\ncycles | 2.00 | 2.00 | 3.00 | 2.00 | 3.00 | 3.00 | 1.50 | 1.50 | 2.00 | 5.00\n\nCycles executing div or sqrt instructions: NA\nCycles loading/storing data              : 3.00\nLongest recurrence chain latency (RecMII): 1.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 3.67\nDispatch  : 5.00\nData deps.: 1.00\nOverall L1: 5.00\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : 0%\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 0%\nFP\nall     : 0%\nload    : NA (no load vectorizable/vectorized instructions)\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : 0%\nadd-sub : 0%\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 0%\nINT+FP\nall     : 0%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : 0%\nadd-sub : 0%\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 0%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 12%\nload   : 12%\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 12%\nFP\nall     : 23%\nload    : NA (no load vectorizable/vectorized instructions)\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : 25%\nadd-sub : 25%\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 18%\nINT+FP\nall     : 18%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : 25%\nadd-sub : 25%\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 15%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 5.00 cycles. At this rate:\n - 1% of peak load performance is reached (0.60 out of 32.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 3% of peak store performance is reached (0.60 out of 16.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Found no such bottlenecks.",
        },
        {
          title = "ASM code",
          txt = "In the binary file, the address of the loop is: 11fc\n\nInstruction                        | Nb FU | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3  | Latency | Recip. throughput\n----------------------------------------------------------------------------------------------------------------------------------------------\nMOVZX (%RDI),%EAX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 1       | 0.50\nVCVTSI2SD %EAX,%XMM2,%XMM0         | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 7       | 1\nVMULSD %XMM5,%XMM0,%XMM0           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 4       | 0.50\nMOVZX 0x1(%RDI),%EAX               | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 1       | 0.50\nVCVTSI2SD %EAX,%XMM2,%XMM1         | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 7       | 1\nVMULSD %XMM4,%XMM1,%XMM1           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 4       | 0.50\nVADDSD %XMM1,%XMM0,%XMM0           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 3       | 0.50\nMOVZX 0x2(%RDI),%EAX               | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 1       | 0.50\nVCVTSI2SD %EAX,%XMM2,%XMM1         | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 7       | 1\nVMULSD %XMM3,%XMM1,%XMM1           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 4       | 0.50\nVADDSD %XMM1,%XMM0,%XMM0           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 3       | 0.50\nVCVTSD2SS %XMM0,%XMM0,%XMM0        | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 4       | 1\nVCVTTSS2SI %XMM0,%EAX              | 2     | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 8       | 1\nMOV %AL,(%RDI)                     | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 4       | 1\nMOV %AL,0x1(%RDI)                  | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 4       | 1\nMOV %AL,0x2(%RDI)                  | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 4       | 1\nADD $0x3,%RDI                      | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0    | 0    | 1       | 0.25\nCMP %RDX,%RDI                      | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0    | 0    | 1       | 0.25\nJNE 11fc <grayscale_weighted+0x23> | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0    | 0    | 1       | 0.50\n",
        },
      },
      header = {
        "4% of peak computational performance is used (1.00 out of 24.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA)\n",
          details = "All SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is not vectorized.\nOnly 18% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 5.00 to 0.75 cycles (6.67x speedup).",
        },
        {
          workaround = " - Reduce the number of FP add instructions\n - Reduce arithmetical operations on array elements\n",
          title = "Execution units bottlenecks",
          txt = "Performance is limited by:\n - execution of FP add operations (the FP add unit is a bottleneck)\n - execution of INT/FP operations in vector registers (the VPU is a bottleneck)\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 5.00 to 3.67 cycles (1.36x speedup).\n",
        },
      },
      potential = {
        {
          workaround = " - Recompile with march=znver1.\nCQA target is Zen but compiler target is \n - Try to change order in which elements are evaluated (using parentheses) in arithmetic expressions containing both ADD/SUB and MUL operations to enable your compiler to generate FMA instructions wherever possible.\nFor instance a + b*c is a valid FMA (MUL then ADD).\nHowever (a+b)* c cannot be translated into an FMA (ADD then MUL).\n",
          title = "FMA",
          txt = "Presence of both ADD/SUB and MUL operations.",
        },
      },
    },
  },
  AVG = {
      hint = {
        {
          details = "These instructions generate more than one micro-operation and only one of them can be decoded during a cycle and the extra micro-operations increase pressure on execution units.\n - VCVTSI2SD: 3 occurrences\n - VCVTTSS2SI: 1 occurrences\n",
          title = "Complex instructions",
          txt = "Detected COMPLEX INSTRUCTIONS.\n",
        },
        {
          workaround = "Avoid mixing data with different types. In particular, check if the type of constants is the same as array elements. Use double instead of single precision only when/where needed by numerical stability and avoid mixing precision.",
          details = " - VCVTSD2SS (FP64 to FP32, scalar): 1 occurrences\n - VCVTSI2SD (INT32/64 to FP64, scalar): 3 occurrences\n - VCVTTSS2SI (FP32 to INT32/64, scalar): 1 occurrences\n",
          title = "Conversion instructions",
          txt = "Detected expensive conversion instructions.",
        },
        {
          title = "Type of elements and instruction set",
          txt = "5 SSE or AVX instructions are processing arithmetic or math operations on double precision FP elements in scalar mode (one at a time).\n",
        },
        {
          title = "Matching between your loop (in the source code) and the binary loop",
          txt = "The binary loop is composed of 5 FP arithmetical operations:\n - 2: addition or subtraction\n - 3: multiply\nThe binary loop is loading 3 bytes (0 double precision FP elements).\nThe binary loop is storing 3 bytes (0 double precision FP elements).",
        },
        {
          title = "Arithmetic intensity",
          txt = "Arithmetic intensity is 0.83 FP operations per loaded or stored byte.",
        },
        {
          workaround = "Unroll your loop if trip count is significantly higher than target unroll factor and if some data references are common to consecutive iterations. This can be done manually. Or by recompiling with -funroll-loops and/or -floop-unroll-and-jam.",
          title = "Unroll opportunity",
          txt = "Loop is potentially data access bound.",
        },
      },
      expert = {
        {
          title = "General properties",
          txt = "nb instructions    : 19\nnb uops            : 22\nloop length        : 68\nused x86 registers : 3\nused mmx registers : 0\nused xmm registers : 6\nused ymm registers : 0\nused zmm registers : 0\nnb stack references: 0\nADD-SUB / MUL ratio: 0.67\n",
        },
        {
          title = "Front-end",
          txt = "ASSUMED MACRO FUSION\nFIT IN UOP CACHE\nmicro-operation queue: 3.67 cycles\nfront end            : 3.67 cycles\n",
        },
        {
          title = "Back-end",
          txt = "       | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3\n----------------------------------------------------------------------------\nuops   | 2.00 | 2.00 | 3.00 | 2.00 | 3.00 | 3.00 | 1.50 | 1.50 | 2.00 | 5.00\ncycles | 2.00 | 2.00 | 3.00 | 2.00 | 3.00 | 3.00 | 1.50 | 1.50 | 2.00 | 5.00\n\nCycles executing div or sqrt instructions: NA\nCycles loading/storing data              : 3.00\nLongest recurrence chain latency (RecMII): 1.00\n",
        },
        {
          title = "Cycles summary",
          txt = "Front-end : 3.67\nDispatch  : 5.00\nData deps.: 1.00\nOverall L1: 5.00\n",
        },
        {
          title = "Vectorization ratios",
          txt = "INT\nall    : 0%\nload   : 0%\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 0%\nFP\nall     : 0%\nload    : NA (no load vectorizable/vectorized instructions)\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : 0%\nadd-sub : 0%\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 0%\nINT+FP\nall     : 0%\nload    : 0%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : 0%\nadd-sub : 0%\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 0%\n",
        },
        {
          title = "Vector efficiency ratios",
          txt = "INT\nall    : 12%\nload   : 12%\nstore  : NA (no store vectorizable/vectorized instructions)\nmul    : NA (no mul vectorizable/vectorized instructions)\nadd-sub: NA (no add-sub vectorizable/vectorized instructions)\nfma    : NA (no fma vectorizable/vectorized instructions)\nother  : 12%\nFP\nall     : 23%\nload    : NA (no load vectorizable/vectorized instructions)\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : 25%\nadd-sub : 25%\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 18%\nINT+FP\nall     : 18%\nload    : 12%\nstore   : NA (no store vectorizable/vectorized instructions)\nmul     : 25%\nadd-sub : 25%\nfma     : NA (no fma vectorizable/vectorized instructions)\ndiv/sqrt: NA (no div/sqrt vectorizable/vectorized instructions)\nother   : 15%\n",
        },
        {
          title = "Cycles and memory resources usage",
          txt = "Assuming all data fit into the L1 cache, each iteration of the binary loop takes 5.00 cycles. At this rate:\n - 1% of peak load performance is reached (0.60 out of 32.00 bytes loaded per cycle (GB/s @ 1GHz))\n - 3% of peak store performance is reached (0.60 out of 16.00 bytes stored per cycle (GB/s @ 1GHz))\n",
        },
        {
          title = "Front-end bottlenecks",
          txt = "Found no such bottlenecks.",
        },
        {
          title = "ASM code",
          txt = "In the binary file, the address of the loop is: 11fc\n\nInstruction                        | Nb FU | ALU0 | ALU1 | ALU2 | ALU3 | AGU0 | AGU1 | FP0  | FP1  | FP2  | FP3  | Latency | Recip. throughput\n----------------------------------------------------------------------------------------------------------------------------------------------\nMOVZX (%RDI),%EAX                  | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 1       | 0.50\nVCVTSI2SD %EAX,%XMM2,%XMM0         | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 7       | 1\nVMULSD %XMM5,%XMM0,%XMM0           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 4       | 0.50\nMOVZX 0x1(%RDI),%EAX               | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 1       | 0.50\nVCVTSI2SD %EAX,%XMM2,%XMM1         | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 7       | 1\nVMULSD %XMM4,%XMM1,%XMM1           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 4       | 0.50\nVADDSD %XMM1,%XMM0,%XMM0           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 3       | 0.50\nMOVZX 0x2(%RDI),%EAX               | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 1       | 0.50\nVCVTSI2SD %EAX,%XMM2,%XMM1         | 2     | 0    | 0    | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 7       | 1\nVMULSD %XMM3,%XMM1,%XMM1           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 4       | 0.50\nVADDSD %XMM1,%XMM0,%XMM0           | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 3       | 0.50\nVCVTSD2SS %XMM0,%XMM0,%XMM0        | 1     | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 4       | 1\nVCVTTSS2SI %XMM0,%EAX              | 2     | 1    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 0    | 1    | 8       | 1\nMOV %AL,(%RDI)                     | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 4       | 1\nMOV %AL,0x1(%RDI)                  | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 4       | 1\nMOV %AL,0x2(%RDI)                  | 1     | 0    | 0    | 0    | 0    | 0.50 | 0.50 | 0    | 0    | 0    | 0    | 4       | 1\nADD $0x3,%RDI                      | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0    | 0    | 1       | 0.25\nCMP %RDX,%RDI                      | 1     | 0.25 | 0.25 | 0.25 | 0.25 | 0    | 0    | 0    | 0    | 0    | 0    | 1       | 0.25\nJNE 11fc <grayscale_weighted+0x23> | 1     | 0.50 | 0    | 0    | 0.50 | 0    | 0    | 0    | 0    | 0    | 0    | 1       | 0.50\n",
        },
      },
      header = {
        "4% of peak computational performance is used (1.00 out of 24.00 FLOP per cycle (GFLOPS @ 1GHz))",
      },
      brief = {
      },
      gain = {
        {
          workaround = " - Try another compiler or update/tune your current one:\n  * recompile with ftree-vectorize (included in O3) to enable loop vectorization and with fassociative-math (included in Ofast or ffast-math) to extend vectorization to FP reductions.\n - Remove inter-iterations dependences from your loop and make it unit-stride:\n  * If your arrays have 2 or more dimensions, check whether elements are accessed contiguously and, otherwise, try to permute loops accordingly\n  * If your loop streams arrays of structures (AoS), try to use structures of arrays instead (SoA)\n",
          details = "All SSE/AVX instructions are used in scalar version (process only one data element in vector registers).\nSince your execution units are vector units, only a vectorized loop can use their full power.\n",
          title = "Vectorization",
          txt = "Your loop is not vectorized.\nOnly 18% of vector register length is used (average across all SSE/AVX instructions).\nBy vectorizing your loop, you can lower the cost of an iteration from 5.00 to 0.75 cycles (6.67x speedup).",
        },
        {
          workaround = " - Reduce the number of FP add instructions\n - Reduce arithmetical operations on array elements\n",
          title = "Execution units bottlenecks",
          txt = "Performance is limited by:\n - execution of FP add operations (the FP add unit is a bottleneck)\n - execution of INT/FP operations in vector registers (the VPU is a bottleneck)\n\nBy removing all these bottlenecks, you can lower the cost of an iteration from 5.00 to 3.67 cycles (1.36x speedup).\n",
        },
      },
      potential = {
        {
          workaround = " - Recompile with march=znver1.\nCQA target is Zen but compiler target is \n - Try to change order in which elements are evaluated (using parentheses) in arithmetic expressions containing both ADD/SUB and MUL operations to enable your compiler to generate FMA instructions wherever possible.\nFor instance a + b*c is a valid FMA (MUL then ADD).\nHowever (a+b)* c cannot be translated into an FMA (ADD then MUL).\n",
          title = "FMA",
          txt = "Presence of both ADD/SUB and MUL operations.",
        },
      },
    },
  common = {
    header = {
      "The loop is defined in /home/zakaria/Desktop/Work/AP/sobel_optimisation/sobel.c:18-27.\n",
      "The related source loop is not unrolled or unrolled with no peel/tail loop.",
    },
    nb_paths = 1,
  },
}
