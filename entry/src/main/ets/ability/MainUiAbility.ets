import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import Logger from '../utils/Logger';
import { MAIN_ARTICAL_DETAIL_CLICK } from '../views/Article';

export default class MainUiAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (error) {
      // TODO: Implement error handling.
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 监听页面逻辑
    let eventHub = this.context.eventHub
    eventHub.on(MAIN_ARTICAL_DETAIL_CLICK, (url?: string) => {
      if (url != null && url.length > 0) {
        Logger.i("main-artical-detail-click, url is: ".concat(url))

      }
    })

    // 加载页面
    windowStage.loadContent('pages/Main', (err) => {

    })
  }
}