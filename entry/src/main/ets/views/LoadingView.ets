import { LoadingState } from '../model/mainpage/LoadingState'

@Component
export struct LoadingView {

  @Prop
  @Watch("onLoadingStateChange")
  loadingState: LoadingState = LoadingState.NONE

  @State
  private contentString: Resource | null = null

  fontSize: number = 14

  onErrorClick?: () => void

  onLoadingStateChange() {
    switch (this.loadingState) {
      case LoadingState.INIT_LOADING:
      case LoadingState.MORE_LOADING: {
        this.contentString = $r("app.string.list_bottom_state_loading")
        break
      }
      case LoadingState.SUCCESS: {
        this.contentString = $r("app.string.list_bottom_state_success")
        break
      }
      case LoadingState.FINISH: {
        this.contentString = $r("app.string.list_bottom_state_finish")
        break
      }
      case LoadingState.ERROR: {
        this.contentString = $r("app.string.list_bottom_state_error")
        break
      }
      default: {
        this.contentString = null
      }
    }
  }

  aboutToAppear(): void {
    this.onLoadingStateChange()
  }

  build() {
    Column() {
      if (this.contentString != null) {
        Text(this.contentString)
          .fontSize(this.fontSize)
          .fontColor($r("app.color.second_text"))
          .textAlign(TextAlign.Center)
          .width("100%")
          .padding(12)
          .onClick(() => {
            if (this.loadingState == LoadingState.ERROR && this.onErrorClick != null) {
              this.onErrorClick()
            }
          })
      }
    }
    .align(Alignment.Center)
  }

}