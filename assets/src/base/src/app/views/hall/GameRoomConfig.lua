local gameRoomConfig = {

    [1001] = { -- 奔驰宝马ok
        size = cc.size(463, 235),
        scollView_offsets = {
            row = 10,
            col = 100
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_bcbm/cdt_bcbm.ExportJson",
            aniName = "cdt_bcbm", -- 动画名字
            playName = "bcbm", -- 动画播放的名字
            pos = cc.p(231.5, 117.5)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(350, 80),
            size = cc.size(196, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(350, 40),
            size = cc.size(196, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [1005] = { -- 财神到ok
        size = cc.size(278, 414),
        titleX = 139,
        titleY = 135,
        scollView_offsets = {
            row = 40,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 60,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_csd/cdt_csd.ExportJson",
            aniName = "cdt_csd", -- 动画名字
            playName = "csd", -- 动画播放的名字
            pos = cc.p(139, 207)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(139, 100),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(139, 65),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [1006] = { -- 红包扫雷
        size = cc.size(278, 414),
        scollView_offsets = {
            row = 40,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 60,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_hbsl/cdt_hbsl.ExportJson",
            aniName = "cdt_hbsl", -- 动画名字
            playName = "hbsl", -- 动画播放的名字
            pos = cc.p(139, 207)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(139, 70),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(139, 35),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [1004] = { -- 欢乐30秒
        size = cc.size(279, 414),
        scollView_offsets = {
            row = 40,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 60,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_hl30m/cdt_hl30m.ExportJson",
            aniName = "cdt_hl30m", -- 动画名字
            playName = "hl30m", -- 动画播放的名字
            pos = cc.p(139, 207)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(139, 70),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(139, 35),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [10] = { -- 欢乐至尊
        size = cc.size(278, 414),
        scollView_offsets = {
            row = 40,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 60,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_hlzz/cdt_hlzz.ExportJson",
            aniName = "cdt_hlzz", -- 动画名字
            playName = "hlzz", -- 动画播放的名字
            pos = cc.p(139, 207)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(139, 70),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(139, 35),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [27] = { -- 火拼牛牛ok
        size = cc.size(467, 222),
        titleX = 330,
        titleY = 160,
        scollView_offsets = {
            row = 40,
            col = 120
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 20,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_hpnn/cdt_hpnn.ExportJson",
            aniName = "cdt_hpnn", -- 动画名字
            playName = "cdt_hpnn", -- 动画播放的名字
            pos = cc.p(233, 111)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(330, 80),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(330, 40),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [204] = { -- 九连夺宝ok
        size = cc.size(278, 450),
        titleX = 139,
        titleY = 120,
        scollView_offsets = {
            row = 0,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 50,
            right = 0,
            top = 0,
            bottom = 20
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_jldb/cdt_jldb.ExportJson",
            aniName = "cdt_jldb", -- 动画名字
            playName = "cdt_jldb", -- 动画播放的名字
            pos = cc.p(139, 225)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(139, 55),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(139, 25),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [1009] = { -- 金瓶梅ok
        size = cc.size(282, 454),
        titleX = 141,
        titleY = 145,
        scollView_offsets = {
            row = 40,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 30,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_jpm/cdt_jpm.ExportJson",
            aniName = "cdt_jpm", -- 动画名字
            playName = "cdt_jpm", -- 动画播放的名字
            pos = cc.p(143, 227)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(143, 80),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(143, 45),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [1008] = { -- 僵尸风云ok
        size = cc.size(232, 333),
        titleX = 116,
        titleY = 140,
        scollView_offsets = {
            row = 40,
            col = 80
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 80,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_jsfy/cdt_jsfy.ExportJson",
            aniName = "cdt_jsfy", -- 动画名字
            playName = "jsfy", -- 动画播放的名字
            pos = cc.p(116, 167)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(116, 60),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(116, 20),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [1002] = { -- 连环夺宝ok
        size = cc.size(274, 435),
        titleX = 137,
        titleY = 160,
        scollView_offsets = {
            row = 10,
            col = 50
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 40,
            right = 40,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_lhdb/cdt_lhdb.ExportJson",
            aniName = "cdt_lhdb", -- 动画名字
            playName = "jldb", -- 动画播放的名字
            pos = cc.p(137, 217)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(137, 100),
            size = cc.size(196, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(137, 65),
            size = cc.size(196, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [33] = { -- 李逵劈鱼ok
        size = cc.size(257, 388),
        titleX = 128,
        titleY = 360,
        scollView_offsets = {
            row = 40,
            col = 60
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 60,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_lkpy/cdt_lkpy.ExportJson",
            aniName = "cdt_lkpy", -- 动画名字
            playName = "cdt_lkpy", -- 动画播放的名字
            pos = cc.p(128, 194)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(128, 70),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(128, 30),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        },
        txt_other = {
            word = {LangCtrl:getLang().word342, LangCtrl:getLang().word343, LangCtrl:getLang().word344, LangCtrl:getLang().word345},
            pos = cc.p(138, 120),
            fntPath = "app/hall/gamelist/gameroom/fnt_lkpy.fnt"
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        --]]
    },

    [205] = { -- 水果狂欢ok
        size = cc.size(274, 435),
        titleX = 137,
        titleY = 160,
        scollView_offsets = {
            row = 10,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 50,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_sgkh/cdt_sgkh.ExportJson",
            aniName = "cdt_sgkh", -- 动画名字
            playName = "cdt_sgkh", -- 动画播放的名字
            pos = cc.p(137, 218)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(137, 100),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(137, 60),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [203] = { -- 水浒传ok
        size = cc.size(425, 226),
        titleX = 310,
        titleY = 160,
        scollView_offsets = {
            row = 20,
            col = 180
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_shz/cdt_shz.ExportJson",
            aniName = "cdt_shz", -- 动画名字
            playName = "cdt_shz", -- 动画播放的名字
            pos = cc.p(212, 113)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(310, 80),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(310, 35),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [7] = { -- 十三水
        size = cc.size(463, 235),
        scollView_offsets = {
            row = 10,
            col = 100
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_sss/cdt_sss.ExportJson",
            aniName = "cdt_sss", -- 动画名字
            playName = "sss", -- 动画播放的名字
            pos = cc.p(231.5, 117.5)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(330, 130),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(330, 90),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        },
        node_dizhu = { -- 底注
            bgPath = "img_ztdb",
            pos = cc.p(330, 170),
            size = cc.size(196, 36),
            wordDirect = "right" -- 对齐方式
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        txt_other = nil, --其他文字图片
        --]]
    },

    [28] = { -- 通比牛牛ok
        size = cc.size(284, 440),
        titleX = 142,
        titleY = 168,
        scollView_offsets = {
            row = 40,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 35,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_tbnn/cdt_tbnn.ExportJson",
            aniName = "cdt_tbnn", -- 动画名字
            playName = "cdt_tbnn", -- 动画播放的名字
            pos = cc.p(142, 220)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(142, 80),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(142, 45),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        },
        node_dizhu = { -- 底注
            bgPath = "img_ztdb",
            pos = cc.p(142, 120),
            size = cc.size(196, 36),
            wordDirect = "right" -- 对齐方式
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        txt_other = nil, --其他文字图片
        --]]
    },

    [1003] = { -- 黄金战车ok
        size = cc.size(490, 206),
        titleX = 330,
        titleY = 168,
        scollView_offsets = {
            row = 30,
            col = 120
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 0,
            right = 0,
            top = 20,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_hjlc/cdt_hjlc.ExportJson",
            aniName = "cdt_hjlc", -- 动画名字
            playName = "cdt_hjlc", -- 动画播放的名字
            pos = cc.p(245, 103)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(330, 75),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(330, 35),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        },
        node_dizhu = { -- 底注
            bgPath = "img_ztdb",
            pos = cc.p(330, 115),
            size = cc.size(196, 36),
            wordDirect = "right" -- 对齐方式
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        txt_other = nil, --其他文字图片
        --]]
    },

    [1010] = { -- 秘鲁传说ok
        size = cc.size(284, 440),
        titleX = 142,
        titleY = 160,
        scollView_offsets = {
            row = 40,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 40,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_blcs/cdt_blcs.ExportJson",
            aniName = "cdt_blcs", -- 动画名字
            playName = "blcs_", -- 动画播放的名字
            pos = cc.p(142, 220)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(142, 80),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(142, 45),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        },
        node_dizhu = { -- 底注
            bgPath = "img_ztdb",
            pos = cc.p(142, 115),
            size = cc.size(196, 36),
            wordDirect = "right" -- 对齐方式
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        txt_other = nil, --其他文字图片
        --]]
    },

    [1011] = { -- 跳高高ok
        size = cc.size(282, 452),
        titleX = 141,
        titleY = 160,
        scollView_offsets = {
            row = 0,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 40,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_tgg/cdt_tgg.ExportJson",
            aniName = "cdt_tgg", -- 动画名字
            playName = "tgg", -- 动画播放的名字
            pos = cc.p(141, 226)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(141, 80),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(141, 40),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    },

    [1012] = { -- 麻将胡了
        size = cc.size(284, 435),
        titleX = 142,
        titleY = 150,
        scollView_offsets = {
            row = 10,
            col = 40
        }, -- 设置房间icon之间的距离
        scollView_pads = {
            left = 40,
            right = 0,
            top = 0,
            bottom = 0
        }, -- 设置整个房间控件的边距
        anil_bg = {
            -- 房间动画
            jsonPath = "app/hall/gamelist/cdt_ani/cdt_mjhl/cdt_mjhl.ExportJson",
            aniName = "cdt_mjhl", -- 动画名字
            playName = "cdt_mjhl", -- 动画播放的名字
            pos = cc.p(142, 218)
        },
        node_onLineCount = {
            -- 在线人数
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_rs.png", -- 图标
            pos = cc.p(142, 90),
            size = cc.size(200, 28),
            wordDirect = "right" -- 对齐方式
        },
        node_minEnter = {
            -- 最小进入金币
            bgPath = "img_ztdbt_", -- 背景
            iconPath = "icon_cdt_jb.png", -- 图标
            pos = cc.p(142, 50),
            size = cc.size(200, 28),
            wordDirect = "right", -- 对齐方式
            samelineChk = false -- 是否和在线人数在同一个框中，如果为true，则背景和尺寸设置忽略
        }

        --[[
        img_bg = {path = ''}, --房间icon背景
        img_word = {path = '', pos = cc.p(130, 100)}, --文字图片例如：初级房，中级房。。。。。
        node_dizhu = {--底注
            bgPath = 'img_ztdb', 
            pos = cc.p(120, 210), 
            size = cc.size(196, 36), 
            wordDirect = 'right' --对齐方式
        },
        txt_other = nil, --其他文字图片
        --]]
    }
}

return gameRoomConfig
