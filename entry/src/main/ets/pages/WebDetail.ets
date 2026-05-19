import webview from "@ohos.web.webview"

@Component
export struct WebDetail {

  @Prop url: string

  private controller = new webview.WebviewController()

  build() {
    NavDestination() {
      Column() {
        Web({
          src: this.url,
          controller: this.controller
        })
          .width('100%')
          .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
