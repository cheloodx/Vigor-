const { withDangerousMod } = require('expo/config-plugins');
const fs = require('fs');
const path = require('path');

function withDisableSandboxing(config) {
  return withDangerousMod(config, [
    'ios',
    async (config) => {
      const platformRoot = config.modRequest.platformProjectRoot;

      // 1. Patch Podfile: add ENABLE_USER_SCRIPT_SANDBOXING = NO for all Pod targets
      const podfilePath = path.join(platformRoot, 'Podfile');
      if (fs.existsSync(podfilePath)) {
        let podfileContent = fs.readFileSync(podfilePath, 'utf8');
        if (!podfileContent.includes('ENABLE_USER_SCRIPT_SANDBOXING')) {
          const insertCode = `
    # Fix Xcode 15/16 sandbox errors with React Native
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      end
    end
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
    end`;
          const postInstallEnd = podfileContent.lastIndexOf('  end\nend');
          if (postInstallEnd !== -1) {
            podfileContent = podfileContent.slice(0, postInstallEnd) + insertCode + '\n' + podfileContent.slice(postInstallEnd);
            fs.writeFileSync(podfilePath, podfileContent);
          }
        }
      }

      // 2. Patch the main project .pbxproj to disable sandboxing at project level
      const pbxprojPath = path.join(platformRoot, 'SatConnect.xcodeproj', 'project.pbxproj');
      if (fs.existsSync(pbxprojPath)) {
        let pbxContent = fs.readFileSync(pbxprojPath, 'utf8');
        if (!pbxContent.includes('ENABLE_USER_SCRIPT_SANDBOXING')) {
          pbxContent = pbxContent.replace(
            /buildSettings = \{/g,
            'buildSettings = {\n\t\t\t\tENABLE_USER_SCRIPT_SANDBOXING = NO;'
          );
          fs.writeFileSync(pbxprojPath, pbxContent);
        }
      }

      return config;
    },
  ]);
}

module.exports = withDisableSandboxing;
