local Ninepatch = {}

Ninepatch.VERSION = 0.1
Ninepatch.AUTHOR = 'Hadestia'
errorString = 'Unauthorize use of Function'

local CONTROLLER_ID = 'hdst.vendorMainController'

function secure(cmd)
    -- lets just prevent users to call this whenever they found this function
    if not cmd == CONTROLLER_ID then
        error(errorString)
    end
end

function Ninepatch.__tostring()
    return 'Custom NinePatches By Hadestia'
end

Ninepatch.appended_draft = {}
Ninepatch.available_ninepatch = {}

Ninepatch.ids = {
    '$hdst.ninepatch_groupbox',
    '$hdst.ninepatch_groupbox_no_edge',
    '$hdst.ninepatch_groupbox_no_edge_hollow',
    '$hdst.ninepatch_groupbox_inset',
    '$hdst.ninepatch_groupbox_piece_left',
    '$hdst.ninepatch_groupbox_piece_right',
    '$hdst.ninepatch_groupbox_piece_top',
    '$hdst.ninepatch_groupbox_piece_bottom'
}

local raw_draft = {
    [[
    [{
        "id": "$hdst.ninepatch_groupbox",
        "type": "animation",
        "frames": [
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "y": 0,
                "count": 3
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "y": 6,
                "count": 3
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "y": 12,
                "count": 3
            }
        ],
        "meta": {
            "name": "GROUP_BOX"
        }
    }]
    ]],
    [[
    [{
        "id": "$hdst.ninepatch_groupbox_inset",
        "type": "animation",
        "frames": [
            {
                "bmp": "frames/group_box_inset.png",
                "w": 3,
                "h": 3,
                "y": 0,
                "count": 3
            },
            {
                "bmp": "frames/group_box_inset.png",
                "w": 3,
                "h": 3,
                "y": 3,
                "count": 3
            },
            {
                "bmp": "frames/group_box_inset.png",
                "w": 3,
                "h": 3,
                "y": 6,
                "count": 3
            }
        ],
        "meta": {
            "name": "GROUP_BOX_INSET"
        }
    }]
    ]],
    [[
    [{
        "id": "$hdst.ninepatch_groupbox_no_edge",
        "type": "animation",
        "frames": [
            {
                "bmp": "frames/group_box_no_edge.png",
                "w": 6,
                "h": 6,
                "y": 0,
                "count": 3
            },
            {
                "bmp": "frames/group_box_no_edge.png",
                "w": 6,
                "h": 6,
                "y": 6,
                "count": 3
            },
            {
                "bmp": "frames/group_box_no_edge.png",
                "w": 6,
                "h": 6,
                "y": 12,
                "count": 3
            }
        ],
        "meta": {
            "name": "GROUP_BOX_NOEDGE"
        }
    }]
    ]],
    [[
    [{
        "id": "$hdst.ninepatch_groupbox_no_edge_hollow",
        "type": "animation",
        "frames": [
            {
                "bmp": "frames/group_box_hollow_no_edge.png",
                "w": 6,
                "h": 6,
                "y": 0,
                "count": 3
            },
            {
                "bmp": "frames/group_box_hollow_no_edge.png",
                "w": 6,
                "h": 6,
                "y": 6,
                "count": 3
            },
            {
                "bmp": "frames/group_box_hollow_no_edge.png",
                "w": 6,
                "h": 6,
                "y": 12,
                "count": 3
            }
        ],
        "meta": {
            "name": "GROUP_BOX_NOEDGE_HOLLOW"
        }
    }]
    ]],
    [[
    [{
        "id": "$hdst.ninepatch_groupbox_piece_right",
        "type": "animation",
        "frames": [
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 0
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 0,
                "count": 2
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 6,
                "count": 2
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 12
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 12,
                "count": 2
            }
        ],
        "meta": {
            "name": "GROUP_BOX_PIECE_RIGHT"
        }
    }]
    ]],
    [[
    [{
        "id": "$hdst.ninepatch_groupbox_piece_left",
        "type": "animation",
        "frames": [
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 0
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 0
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 0
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 12
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 12
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 12
            }
        ],
        "meta": {
            "name": "GROUP_BOX_PIECE_LEFT"
        }
    }]
    ]],
    [[
    [{
        "id": "$hdst.ninepatch_groupbox_piece_top",
        "type": "animation",
        "frames": [
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 0
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 0
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 0
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 12,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 12
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 12
            }
        ],
        "meta": {
            "name": "GROUP_BOX_PIECE_TOP"
        }
    }]
    ]],
    [[
    [{
        "id": "$hdst.ninepatch_groupbox_piece_bottom",
        "type": "animation",
        "frames": [
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 0
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 12,
                "y": 12
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 12,
                "y": 6
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 0,
                "y": 12
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 6,
                "y": 12
            },
            {
                "bmp": "frames/group_box.png",
                "w": 6,
                "h": 6,
                "x": 12,
                "y": 12
            }
        ],
        "meta": {
            "name": "GROUP_BOX_PIECE_BOTTOM"
        }
    }]
    ]]
}

-- appends all the ninepatch as draft
function Ninepatch.appendRaw(cmd)
    secure(cmd)
    for i = 1, #Ninepatch.ids do
        if not Draft.getDraft(Ninepatch.ids[i]) then
            Draft.append(raw_draft[i])
            Ninepatch.appended_draft[Ninepatch.ids[i]] = true
        else
            Ninepatch.appended_draft[Ninepatch.ids[i]] = true
        end
    end
end

-- get all the frames of all appended drafts
function Ninepatch.init(getvalues, cmd)
    secure(cmd)
    for key, _ in pairs(Ninepatch.appended_draft) do
        local np = Draft.getDraft(key)
        if np then
            local meta = np:getMeta()
            Ninepatch.available_ninepatch[meta.name] = np:getFrame(1)
        end
    end
    -- whether to return all the index frames
    if getvalues then
        return Ninepatch.available_ninepatch
    end
end

return Ninepatch