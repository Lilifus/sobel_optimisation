_cqa_uarch_const = {
  ["uop cache capacity"] = 1300,
  ["ports"] = {
    ["FP ADD"] = {
      [1] = 8,
      [2] = 9,
    },
    ["store address"] = {
      [1] = 4,
      [2] = 5,
    },
    ["FP store data"] = {
      [1] = 8,
    },
    ["DIV/SQRT"] = {
      [1] = 9,
    },
    ["load"] = {
      [1] = 4,
      [2] = 5,
    },
    ["misc"] = {
      [1] = 0,
      [2] = 1,
      [3] = 2,
      [4] = 3,
    },
    ["VPU"] = {
      [1] = 6,
      [2] = 7,
      [3] = 8,
      [4] = 9,
    },
    ["FP FMA"] = {
      [1] = 6,
      [2] = 7,
    },
    ["FP MUL"] = {
      [1] = 6,
      [2] = 7,
    },
  },
  ["INT vector size in bytes"] = 32,
  ["vector size in bytes"] = 32,
  ["store unit native width"] = 16,
  ["UQ throughput"] = 6,
  ["vector-unaligned optimal pattern"] = "1x128",
  ["FP DIV/SQRT unit native width"] = 16,
  ["load unit native width"] = 16,
  ["IQ throughput"] = 4,
  ["NOP 0f 1f decode"] = "fast",
  ["bytes fetched per cycle"] = 32,
  ["retire throughput"] = 8,
  ["nb execution ports"] = 10,
}
