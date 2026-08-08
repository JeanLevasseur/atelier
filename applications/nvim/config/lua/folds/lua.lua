local module = {}

local function is_separator(line)
    return line:match("^%-%-%s=+%s*$") ~= nil
end

local function is_banner_line(line)
    if is_separator(line) then
        return false
    end

    return line:match("^%s*$") ~= nil
        or line:match("^%s*%-%-.*$") ~= nil
end

local function parse_sections()
    local sections = {}
    local last_line = vim.fn.line("$")
    local line = 1

    while line <= last_line do
        if is_separator(vim.fn.getline(line)) then
            local banner_start = line
            local cursor = line + 1

            -- A banner may contain any number of blank or commented lines.
            while cursor <= last_line
                and is_banner_line(vim.fn.getline(cursor))
            do
                cursor = cursor + 1
            end

            -- The first non-banner line must be the closing separator.
            if cursor <= last_line
                and is_separator(vim.fn.getline(cursor))
            then
                local banner_end = cursor

                sections[#sections + 1] = {
                    banner_start = banner_start,
                    banner_end = banner_end,
                }

                line = banner_end + 1
            else
                -- This separator did not form a complete banner.
                line = banner_start + 1
            end
        else
            line = line + 1
        end
    end

    -- Determine the content range of every section.
    for index, section in ipairs(sections) do
        section.content_start = section.banner_end + 1

        local next_section = sections[index + 1]

        if next_section then
            section.content_end = next_section.banner_start - 1
        else
            section.content_end = last_line
        end
    end

    return sections
end

local function section_at_line(sections, lnum)
    for _, section in ipairs(sections) do
        if lnum >= section.banner_start
            and lnum <= section.banner_end
        then
            return section
        end
    end

    return nil
end

local function open_section(section)
    if section.content_start > section.content_end then
        return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)

    vim.api.nvim_win_set_cursor(0, {
        section.content_start,
        0,
    })

    vim.cmd("normal! zo")

    vim.api.nvim_win_set_cursor(0, cursor)
end

local function close_section(section)
    if section.content_start > section.content_end then
        return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)

    vim.api.nvim_win_set_cursor(0, {
        section.content_start,
        0,
    })

    vim.cmd("normal! zc")

    vim.api.nvim_win_set_cursor(0, cursor)
end

function module.foldexpr()
    local lnum = vim.v.lnum
    local sections = parse_sections()

    -- Banners are always visible.
    for _, section in ipairs(sections) do
        if lnum >= section.banner_start
            and lnum <= section.banner_end
        then
            return 0
        end

        if lnum >= section.content_start
            and lnum <= section.content_end
        then
            return 1
        end
    end

    return 0
end

function module.open()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local sections = parse_sections()
    local section = section_at_line(sections, lnum)

    if section then
        open_section(section)
        return
    end

    vim.cmd("normal! zo")
end

function module.close()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local sections = parse_sections()
    local section = section_at_line(sections, lnum)

    if section then
        close_section(section)
        return
    end

    vim.cmd("normal! zc")
end

function module.toggle()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local sections = parse_sections()
    local section = section_at_line(sections, lnum)

    if not section then
        vim.cmd("normal! za")
        return
    end

    if section.content_start > section.content_end then
        return
    end

    if vim.fn.foldclosed(section.content_start) == -1 then
        close_section(section)
    else
        open_section(section)
    end
end

return module
