return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 30,
  height = 20,
  tilewidth = 20,
  tileheight = 20,
  nextlayerid = 11,
  nextobjectid = 24,
  properties = {},
  tilesets = {
    {
      name = "unnamed_3482",
      firstgid = 1,
      class = "",
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "images/unnamed_3482.png",
      imagewidth = 160,
      imageheight = 180,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 20,
        height = 20
      },
      properties = {},
      wangsets = {
        {
          name = "big_wall",
          class = "",
          tile = -1,
          wangsettype = "corner",
          properties = {},
          colors = {
            {
              color = { 255, 0, 0 },
              name = "idk",
              class = "",
              probability = 1,
              tile = -1,
              properties = {}
            },
            {
              color = { 0, 0, 255 },
              name = "door",
              class = "",
              probability = 1,
              tile = -1,
              properties = {}
            }
          },
          wangtiles = {
            {
              wangid = { 0, 0, 0, 1, 0, 0, 0, 0 },
              tileid = 5
            },
            {
              wangid = { 0, 0, 0, 1, 0, 1, 0, 0 },
              tileid = 6
            },
            {
              wangid = { 0, 0, 0, 0, 0, 1, 0, 0 },
              tileid = 7
            },
            {
              wangid = { 0, 1, 0, 1, 0, 0, 0, 0 },
              tileid = 13
            },
            {
              wangid = { 0, 1, 0, 1, 0, 1, 0, 1 },
              tileid = 14
            },
            {
              wangid = { 0, 0, 0, 0, 0, 1, 0, 1 },
              tileid = 15
            },
            {
              wangid = { 0, 1, 0, 0, 0, 0, 0, 0 },
              tileid = 21
            },
            {
              wangid = { 0, 1, 0, 0, 0, 0, 0, 1 },
              tileid = 22
            },
            {
              wangid = { 0, 0, 0, 0, 0, 0, 0, 1 },
              tileid = 23
            },
            {
              wangid = { 0, 1, 0, 0, 0, 1, 0, 1 },
              tileid = 29
            },
            {
              wangid = { 0, 1, 0, 1, 0, 0, 0, 1 },
              tileid = 30
            },
            {
              wangid = { 0, 0, 0, 1, 0, 1, 0, 1 },
              tileid = 37
            },
            {
              wangid = { 0, 1, 0, 1, 0, 1, 0, 0 },
              tileid = 38
            },
            {
              wangid = { 0, 0, 0, 2, 0, 0, 0, 0 },
              tileid = 46
            },
            {
              wangid = { 0, 0, 0, 0, 0, 2, 0, 0 },
              tileid = 47
            },
            {
              wangid = { 0, 2, 0, 2, 0, 0, 0, 0 },
              tileid = 54
            },
            {
              wangid = { 0, 0, 0, 0, 0, 2, 0, 2 },
              tileid = 55
            },
            {
              wangid = { 0, 2, 0, 0, 0, 0, 0, 0 },
              tileid = 62
            },
            {
              wangid = { 0, 0, 0, 0, 0, 0, 0, 2 },
              tileid = 63
            }
          }
        },
        {
          name = "small_wall",
          class = "",
          tile = -1,
          wangsettype = "corner",
          properties = {},
          colors = {
            {
              color = { 255, 0, 0 },
              name = "ms1",
              class = "",
              probability = 1,
              tile = -1,
              properties = {}
            }
          },
          wangtiles = {
            {
              wangid = { 0, 1, 0, 1, 0, 0, 0, 0 },
              tileid = 1
            },
            {
              wangid = { 0, 1, 0, 1, 0, 1, 0, 1 },
              tileid = 2
            },
            {
              wangid = { 0, 0, 0, 0, 0, 1, 0, 1 },
              tileid = 3
            },
            {
              wangid = { 0, 1, 0, 0, 0, 0, 0, 0 },
              tileid = 9
            },
            {
              wangid = { 0, 1, 0, 0, 0, 0, 0, 1 },
              tileid = 10
            },
            {
              wangid = { 0, 0, 0, 0, 0, 0, 0, 1 },
              tileid = 11
            }
          }
        }
      },
      tilecount = 72,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 30,
      height = 20,
      id = 1,
      name = "图块层 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      chunks = {
        {
          x = 0, y = -16, width = 16, height = 16,
          data = {
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
          }
        },
        {
          x = 0, y = 0, width = 16, height = 16,
          data = {
            9, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 9,
            9, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 9,
            9, 14, 15, 30, 23, 23, 23, 23, 23, 23, 23, 31, 15, 15, 16, 9,
            9, 14, 15, 16, 3, 3, 3, 3, 3, 3, 3, 22, 23, 23, 24, 9,
            9, 14, 15, 16, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 4, 9,
            9, 14, 15, 16, 11, 11, 11, 11, 11, 11, 11, 2, 3, 3, 4, 9,
            9, 14, 15, 16, 9, 9, 9, 9, 9, 9, 9, 10, 11, 11, 12, 9,
            9, 14, 15, 16, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
            9, 14, 15, 16, 9, 9, 9, 9, 9, 9, 9, 9, 6, 7, 8, 9,
            9, 14, 15, 38, 7, 7, 7, 7, 7, 7, 7, 7, 39, 15, 16, 9,
            9, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 9,
            9, 22, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 24, 9,
            9, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 9,
            9, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 9,
            9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 9,
            9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "marks",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "point",
          x = 140,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["direction"] = "right",
            ["id"] = 1,
            ["type"] = "mark"
          }
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "point",
          x = 40,
          y = -50,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["direction"] = "up",
            ["id"] = 2,
            ["type"] = "mark"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 9,
      name = "walls",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 79.3333,
          y = 91.75,
          width = 220.625,
          height = 28.25,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 55.25,
          y = 112.75,
          width = 24.625,
          height = 75.0625,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 77.875,
          y = 180.125,
          width = 168.875,
          height = 18.875,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 160.063,
          width = 60,
          height = 21.4375,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 279.5,
          y = 0,
          width = 20.5,
          height = 98.5,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 161,
          width = 20,
          height = 137,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40.5,
          y = 0.0454545,
          width = 258.5,
          height = 32.4545,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 20,
          y = 0.0454545,
          width = 28,
          height = 299.727,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 47.9688,
          y = 271.781,
          width = 252,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 220.063,
          y = 114.25,
          width = 79.9042,
          height = 25.7333,
          rotation = 0,
          visible = true,
          properties = {
            ["type"] = "wall"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "chests",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 11,
          name = "",
          type = "",
          shape = "point",
          x = 119.5,
          y = -120,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["id"] = 2
          }
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "point",
          x = 189.917,
          y = 129.958,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["give"] = true,
            ["id"] = 1
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 10,
      name = "texts",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 380.295,
          y = -332.862,
          width = 70.7331,
          height = 650.745,
          rotation = 0,
          visible = true,
          properties = {
            ["id"] = 1,
            ["instant"] = true
          }
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = -70.7331,
          y = -277.94,
          width = 46.6006,
          height = 584.172,
          rotation = 0,
          visible = true,
          properties = {
            ["id"] = 2,
            ["instant"] = false
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "saves",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 13,
          name = "",
          type = "",
          shape = "point",
          x = 60,
          y = -220,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["id"] = 1,
            ["room"] = "测试房间 - 左上区域",
            ["x"] = 60,
            ["y"] = -160
          }
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "point",
          x = 340,
          y = -220,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["id"] = 2,
            ["room"] = "测试房间 - 出界",
            ["x"] = 340,
            ["y"] = -160
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "warps",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1.5,
          y = -319.5,
          width = 318.5,
          height = 39.5,
          rotation = 0,
          visible = true,
          properties = {
            ["target"] = "scene_battle"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "signs",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 12,
          name = "",
          type = "",
          shape = "point",
          x = 240,
          y = -120,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["id"] = 1,
            ["type"] = "sign"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 8,
      name = "triggers",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {}
    }
  }
}
