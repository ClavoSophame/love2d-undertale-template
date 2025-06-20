import os
import zipfile
import shutil
import sys

def package_love2d_game(game_folder, output_name="YourGame", love_exe_path="love.exe"):
    try:
        if not os.path.isdir(game_folder):
            raise FileNotFoundError(f"游戏文件夹不存在: {game_folder}")
        
        if not os.path.isfile(love_exe_path):
            love_exe_path = shutil.which("love") or love_exe_path
            if not os.path.isfile(love_exe_path):
                raise FileNotFoundError(f"找不到 love.exe，请确保已安装 LÖVE2D 或提供正确路径")
        
        print(f"正在打包游戏: {game_folder}")
        
        temp_dir = os.path.join(os.path.dirname(game_folder), f"{output_name}_temp")
        if os.path.exists(temp_dir):
            shutil.rmtree(temp_dir)
        os.makedirs(temp_dir)
        
        love_file = os.path.join(temp_dir, "game.love")
        print("创建 .love 存档...")
        with zipfile.ZipFile(love_file, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, _, files in os.walk(game_folder):
                for file in files:
                    if file.endswith(".love"):
                        continue
                    full_path = os.path.join(root, file)
                    arcname = os.path.relpath(full_path, game_folder)
                    zipf.write(full_path, arcname)
        
        output_exe = f"{output_name}.exe"
        print(f"合并生成 {output_exe}...")
        with open(love_exe_path, 'rb') as exe_file:
            exe_data = exe_file.read()
        with open(love_file, 'rb') as love_data:
            game_data = love_data.read()
        
        with open(output_exe, 'wb') as final_exe:
            final_exe.write(exe_data)
            final_exe.write(game_data)
        

        manifest_content = """<?xml version="1.0" encoding="UTF-8"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
  <application xmlns="urn:schemas-microsoft-com:asm.v3">
    <windowsSettings>
      <dpiAwareness xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">PerMonitorV2</dpiAwareness>
    </windowsSettings>
  </application>
</assembly>"""
        
        manifest_file = f"{output_name}.exe.manifest"
        with open(manifest_file, 'w') as mf:
            mf.write(manifest_content)
        
        print(f"成功创建: {output_exe}")
        print(f"DPI 感知 manifest 文件: {manifest_file}")
        shutil.rmtree(temp_dir)
        
        return True
    
    except Exception as e:
        print(f"打包失败: {str(e)}", file=sys.stderr)
        return False

if __name__ == "__main__":
    game_folder = "SoulEngine"
    output_name = "SE"
    
    if len(sys.argv) > 1:
        game_folder = sys.argv[1]
        output_name = sys.argv[2]
    
    success = package_love2d_game(game_folder, output_name)
    
    if success:
        print("打包完成！")
    else:
        print("打包过程中出现错误。")
        sys.exit(1)
