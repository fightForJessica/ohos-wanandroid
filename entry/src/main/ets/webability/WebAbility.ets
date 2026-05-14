import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class WebAbility extends UIAbility {

  private webController: WebviewController | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.log('WebViewAbility onCreate');
    // 初始化WebView控制器
    this.webController = new WebviewController();
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    console.log('WebViewAbility onWindowStageCreate');

    // 从want中获取传入的URL参数
    const url = this.getUrlFromWant();

    windowStage.loadContent('pages/WebViewPage', (err, data) => {
      if (err.code) {
        console.error('Failed to load content: ' + JSON.stringify(err));
        return;
      }

      // 将WebController和URL传递给页面
      windowStage.getMainWindow((err, mainWindow) => {
        if (!err) {
          const webViewPage = windowStage.getUIContext().getRouter().getPages()[0];
          if (webViewPage && webViewPage['setWebController']) {
            webViewPage['setWebController'](this.webController);
            if (url) {
              webViewPage['loadUrl'](url);
            }
          }
        }
      });
    });
  }

  private getUrlFromWant(): string | null {
    // 从want参数中获取URL
    const url = this.want?.parameters?.url as string;
    if (url && url.startsWith('http')) {
      return url;
    }

    // 也可以从want的data中获取
    const dataUrl = this.want?.data as string;
    if (dataUrl && dataUrl.startsWith('http')) {
      return dataUrl;
    }

    throw Error("invalid url")
  }

  onWindowStageDestroy() {
    console.log('WebViewAbility onWindowStageDestroy');
    // 清理WebView资源
    this.releaseWebView();
  }

  onDestroy() {
    console.log('WebViewAbility onDestroy');
    // 确保资源被释放
    this.releaseWebView();
  }

  private releaseWebView() {
    if (this.webController) {
      try {
        // 停止所有加载
        this.webController.stop();
        // 清空缓存
        this.webController.clearHistory();
        // 销毁WebView
        this.webController.destroy();
        this.webController = null;
        console.log('WebView resources released successfully');
      } catch (error) {
        console.error('Failed to release WebView resources: ' + JSON.stringify(error));
      }
    }
  }

}
