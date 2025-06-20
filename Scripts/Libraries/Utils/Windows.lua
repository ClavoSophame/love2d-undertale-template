local ffi = require("ffi")
local bit = require("bit")

local user32 = ffi.load("user32")
local gdi32 = ffi.load("gdi32")

ffi.cdef[[
    typedef void* HWND;
    typedef const char* LPCSTR;
    typedef long LONG;
    typedef unsigned char BYTE;
    typedef unsigned long DWORD;
    typedef unsigned int UINT;

    HWND FindWindowA(LPCSTR lpClassName, LPCSTR lpWindowName);
    LONG GetWindowLongA(HWND hWnd, int nIndex);
    LONG SetWindowLongA(HWND hWnd, int nIndex, LONG dwNewLong);
    int SetLayeredWindowAttributes(HWND hwnd, BYTE crKey, BYTE bAlpha, DWORD dwFlags);
    int SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, UINT uFlags);

    static const int GWL_STYLE = -16;
    static const int GWL_EXSTYLE = -20;
    static const int WS_POPUP = 0x80000000;
    static const int WS_VISIBLE = 0x10000000;
    static const int WS_EX_LAYERED = 0x00080000;
    static const int LWA_COLORKEY = 0x00000001;
    static const int LWA_ALPHA = 0x00000002;
    static const int HWND_TOP = 0;
    static const int SWP_FRAMECHANGED = 0x0020;
    static const int SWP_NOMOVE = 0x0002;
    static const int SWP_NOSIZE = 0x0001;

    typedef void* HDC;
    typedef void* HBITMAP;
    typedef struct {
        LONG left;
        LONG top;
        LONG right;
        LONG bottom;
    } RECT;

    HDC GetDC(HWND hWnd);
    HDC CreateCompatibleDC(HDC hdc);
    HBITMAP CreateCompatibleBitmap(HDC hdc, int cx, int cy);
    HBITMAP SelectObject(HDC hdc, HBITMAP h);
    int BitBlt(HDC hdcDest, int xDest, int yDest, int wDest, int hDest, HDC hdcSrc, int xSrc, int ySrc, DWORD rop);
    int GetDIBits(HDC hdc, HBITMAP hbmp, UINT uStartScan, UINT cScanLines, void* lpvBits, void* lpbmi, UINT uUsage);
    int DeleteObject(HBITMAP hObject);
    int ReleaseDC(HWND hWnd, HDC hdc);
    int DeleteDC(HDC hdc);
    void* malloc(size_t size);
    void free(void* ptr);

    static const int SRCCOPY = 0x00CC0020;
    static const int BI_RGB = 0;

    typedef struct {
        UINT cbSize;
        UINT style;
        void* lpfnWndProc;
        int cbClsExtra;
        int cbWndExtra;
        void* hInstance;
        void* hIcon;
        void* hCursor;
        void* hbrBackground;
        const wchar_t* lpszMenuName;
        const wchar_t* lpszClassName;
        void* hIconSm;
    } WNDCLASSEXW;

    typedef long (*WNDPROC)(void* hwnd, unsigned int msg, unsigned long wParam, long lParam);

    static const int WM_DESTROY = 0x0002;
    static const int WM_PAINT = 0x000F;
    static const int DT_CENTER = 0x0001;
    static const int DT_VCENTER = 0x0004;
    static const int DT_SINGLELINE = 0x0020;

    void* GetModuleHandleW(const wchar_t* lpModuleName);
    void* CreateWindowExW(unsigned long dwExStyle, const wchar_t* lpClassName, const wchar_t* lpWindowName, unsigned long dwStyle, int x, int y, int nWidth, int nHeight, void* hWndParent, void* hMenu, void* hInstance, void* lpParam);
    int ShowWindow(void* hWnd, int nCmdShow);
    int UpdateWindow(void* hWnd);
    int GetMessageW(void* lpMsg, void* hWnd, unsigned int wMsgFilterMin, unsigned int wMsgFilterMax);
    int TranslateMessage(const void* lpMsg);
    int DispatchMessageW(const void* lpMsg);
    unsigned short RegisterClassExW(const WNDCLASSEXW* lpwcx);

    static const int WS_OVERLAPPED = 0x00000000;
    static const int WS_CAPTION = 0x00C00000;
    static const int WS_SYSMENU = 0x00080000;
    static const int WS_THICKFRAME = 0x00040000;
    static const int WS_MINIMIZEBOX = 0x00020000;
    static const int WS_MAXIMIZEBOX = 0x00010000;

    static const int WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
    long DefWindowProcW(void* hwnd, unsigned int msg, unsigned long wParam, long lParam);
]]

local window = {}

--- Get the handle of the LÖVE2D window.
---This function attempts to find the handle of the LÖVE2D window using the "SDL_app" class name.
---@return hwnd HWND The handle of the window, or nil if not found.
function window.getHandle()
    local hwnd = user32.FindWindowA("SDL_app", nil)
    if hwnd == nil then
        print("Failed to find LÖVE2D window!")
        return false
    end
    return hwnd
end

---Set the transparency of a window.
---This function sets the transparency level of a window using the alpha value.
---@param hwnd HWND The handle of the window.
---@param alpha BYTE The transparency level (0-255).
---@return boolean True if successful, false otherwise.
function window.setTransparency(hwnd, alpha)
    if not hwnd then return false end

    local exStyle = user32.GetWindowLongA(hwnd, ffi.C.GWL_EXSTYLE)
    user32.SetWindowLongA(hwnd, ffi.C.GWL_EXSTYLE, bit.bor(exStyle, ffi.C.WS_EX_LAYERED))

    user32.SetLayeredWindowAttributes(hwnd, 0, alpha, ffi.C.LWA_ALPHA)

    local hwndTop = ffi.cast("HWND", ffi.C.HWND_TOP)

    user32.SetWindowPos(hwnd, hwndTop, 0, 0, 0, 0,
        bit.bor(ffi.C.SWP_FRAMECHANGED, ffi.C.SWP_NOMOVE, ffi.C.SWP_NOSIZE))
    return true
end

--- Set the background of a window to be transparent.
-- This function sets the background of a window to be transparent using a color key or alpha value.
---@param hwnd HWND The handle of the window.
---@param colorKey BYTE The color key for transparency.
---@param alpha BYTE The transparency level (0-255).
---@return boolean True if successful, false otherwise.
function window.setBackgroundTransparent(hwnd, colorKey, alpha)
    if not hwnd then return false end

    local exStyle = user32.GetWindowLongA(hwnd, ffi.C.GWL_EXSTYLE)
    user32.SetWindowLongA(hwnd, ffi.C.GWL_EXSTYLE, bit.bor(exStyle, ffi.C.WS_EX_LAYERED))

    if colorKey then
        user32.SetLayeredWindowAttributes(hwnd, colorKey, alpha or 0, ffi.C.LWA_COLORKEY)
    else
        user32.SetLayeredWindowAttributes(hwnd, 0, alpha or 0, ffi.C.LWA_ALPHA)
    end

    local hwndTop = ffi.cast("HWND", ffi.C.HWND_TOP)

    user32.SetWindowPos(hwnd, hwndTop, 0, 0, 0, 0,
        bit.bor(ffi.C.SWP_FRAMECHANGED, ffi.C.SWP_NOMOVE, ffi.C.SWP_NOSIZE))
    return true
end

--- Save a screenshot of a specific region of the screen.
-- This function captures a screenshot of a specified region and saves it to a file.
---@param x number The x-coordinate of the region.
---@param y number The y-coordinate of the region.
---@param w number The width of the region.
---@param h number The height of the region.
---@param path string The file path to save the screenshot.
---@param throughWindow boolean Whether to capture through the window or the entire screen.
---@return boolean True if successful, false otherwise.
function window.saveScreenshot(x, y, w, h, path, throughWindow)
    local function pack_u16_le(n)
        return string.char(n % 256, math.floor(n / 256) % 256)
    end

    local function pack_u32_le(n)
        return string.char(
            n % 256,
            math.floor(n / 256) % 256,
            math.floor(n / 65536) % 256,
            math.floor(n / 16777216) % 256
        )
    end

    local hdcScreen, hwnd
    if not throughWindow then
        hwnd = window.getHandle()
        if not hwnd then return false end
        hdcScreen = user32.GetDC(hwnd)
    else
        hdcScreen = user32.GetDC(nil)
    end
    local hdcMem = gdi32.CreateCompatibleDC(hdcScreen)
    local hBitmap = gdi32.CreateCompatibleBitmap(hdcScreen, w, h)
    gdi32.SelectObject(hdcMem, hBitmap)
    gdi32.BitBlt(hdcMem, 0, 0, w, h, hdcScreen, x, y, ffi.C.SRCCOPY)

    local bmpInfo = ffi.new("struct { int biSize; int biWidth; int biHeight; short biPlanes; short biBitCount; int biCompression; int biSizeImage; int biXPelsPerMeter; int biYPelsPerMeter; int biClrUsed; int biClrImportant; }")
    bmpInfo.biSize = ffi.sizeof(bmpInfo)
    bmpInfo.biWidth = w
    bmpInfo.biHeight = h
    bmpInfo.biPlanes = 1
    bmpInfo.biBitCount = 24
    bmpInfo.biCompression = ffi.C.BI_RGB

    local rowSize = math.floor((bmpInfo.biBitCount * w + 31) / 32) * 4
    local imageSize = rowSize * h
    bmpInfo.biSizeImage = imageSize

    local pixelData = ffi.C.malloc(imageSize)
    gdi32.GetDIBits(hdcMem, hBitmap, 0, h, pixelData, bmpInfo, 0)

    local file = assert(io.open(path, "wb"))

    file:write("BM")
    file:write(pack_u32_le(54 + imageSize))
    file:write(string.rep("\0", 4))
    file:write(pack_u32_le(54))

    file:write(pack_u32_le(40))
    file:write(pack_u32_le(w))
    file:write(pack_u32_le(h))
    file:write(pack_u16_le(1))
    file:write(pack_u16_le(24))
    file:write(pack_u32_le(0))
    file:write(pack_u32_le(imageSize))
    file:write(pack_u32_le(0))
    file:write(pack_u32_le(0))
    file:write(pack_u32_le(0))
    file:write(pack_u32_le(0))

    file:write(ffi.string(pixelData, imageSize))
    file:close()

    ffi.C.free(pixelData)
    gdi32.DeleteObject(hBitmap)
    gdi32.DeleteDC(hdcMem)
    if not throughWindow then
        user32.ReleaseDC(hwnd, hdcScreen)
    else
        user32.ReleaseDC(nil, hdcScreen)
    end

    return true
end

--- Show a dialog box with a message and buttons.
-- This function displays a dialog box with a specified message, buttons, and title.
---@param message string The message to display in the dialog box.
---@param buttons table A table of button labels.
---@param title string The title of the dialog box (default: "提示").
---@return int The index of the button pressed by the user.
function window.showDialog(message, buttons, title)
    title = (title or "info")
    if type(buttons) ~= "table" or #buttons == 0 then
        buttons = {"confirm"}
    end
    local pressed = love.window.showMessageBox(title, message, buttons, "info", true)
    return pressed
end

return window