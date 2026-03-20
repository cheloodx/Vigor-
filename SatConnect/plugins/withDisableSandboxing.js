const { withDangerousMod } = require('expo/config-plugins');
const fs = require('fs');
const path = require('path');

function withDisableSandboxing(config) {
  return withDangerousMod(config, [
    'ios',
    async (config) => {
      const podfilePath = path.join(config.modRequest.platformProjectRoot, 'Podfile');
      let podfileContent = fs.readFileSync(podfilePath, 'utf8');

      // Add ENABLE_USER_SCRIPT_SANDBOXING = NO to fix Xcode 15/16 sandbox errors
      if (!podfileContent.includes('ENABLE_USER_SCRIPT_SANDBOXING')) {
        const searchString = 'react_native_post_install(';
        const insertAfterBlock = `
    # Fix Xcode 15/16 sandbox errors with React Native
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      end
    end`;

        // Find the post_install block's end and insert before it
        const postInstallEnd = podfileContent.lastIndexOf('  end\nend');
        if (postInstallEnd !== -1) {
          podfileContent = podfileContent.slice(0, postInstallEnd) + insertAfterBlock + '\n' + podfileContent.slice(postInstallEnd);
        }
      }

      fs.writeFileSync(podfilePath, podfileContent);
      return config;
    },
  ]);
}

module.exports = withDisableSandboxing;
