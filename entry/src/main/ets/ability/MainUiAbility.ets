import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class MainUiAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (error) {
      // TODO: Implement error handling.
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 加载页面
    windowStage.loadContent('pages/Main', (err) => {

    })
  }
}