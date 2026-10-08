import os
import uuid

def generate_uuid():
    return uuid.uuid4().hex[:24].upper()

def create_project_structure(base_dir):
    app_dir = os.path.join(base_dir, "ChingshinApp")
    xcodeproj_dir = os.path.join(base_dir, "ChingshinApp.xcodeproj")
    
    os.makedirs(os.path.join(app_dir, "Models"), exist_ok=True)
    os.makedirs(os.path.join(app_dir, "Views"), exist_ok=True)
    os.makedirs(os.path.join(app_dir, "Views", "Components"), exist_ok=True)
    os.makedirs(os.path.join(app_dir, "Theme"), exist_ok=True)
    os.makedirs(os.path.join(app_dir, "Assets.xcassets", "AppIcon.appiconset"), exist_ok=True)
    os.makedirs(os.path.join(app_dir, "Assets.xcassets", "AccentColor.colorset"), exist_ok=True)
    os.makedirs(os.path.join(app_dir, "Preview Content"), exist_ok=True)
    os.makedirs(xcodeproj_dir, exist_ok=True)

    # Contents.json for AccentColor
    accent_json = """{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.353",
          "green" : "0.529",
          "red" : "0.000"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}"""
    with open(os.path.join(app_dir, "Assets.xcassets", "AccentColor.colorset", "Contents.json"), "w", encoding="utf-8") as f:
        f.write(accent_json)

    assets_json = """{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}"""
    with open(os.path.join(app_dir, "Assets.xcassets", "Contents.json"), "w", encoding="utf-8") as f:
        f.write(assets_json)

    icon_json = """{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}"""
    with open(os.path.join(app_dir, "Assets.xcassets", "AppIcon.appiconset", "Contents.json"), "w", encoding="utf-8") as f:
        f.write(icon_json)

print("Directory structure setup completed.")
if __name__ == "__main__":
    create_project_structure("/Users/zhao/工作專區/清心ios app")
