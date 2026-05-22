import Logger from '../utils/Logger'
import { MainViewModel } from '../viewmodel/MainViewModel'
import { Artical } from '../views/Article'
import { Project } from '../views/Project'
import { WebDetail } from './WebDetail'

export const OPEN_WEB_DETAIL = "open_web_detail"

@Entry
@Component
struct Main {

  @State
  private viewModel: MainViewModel = new MainViewModel()

  private pageStack: NavPathStack = new NavPathStack()

  private eventHub = this.getUIContext().getHostContext()?.eventHub

  @State
  private webUrl: string = ''

  // 路由方法
  @Builder
  private PageMap(name: string) {
    if (name == 'WebDetail') {
      WebDetail({ url: this.webUrl })
    }
  }

  aboutToAppear(): void {
    this.eventHub?.on(OPEN_WEB_DETAIL, (url?: string) => {
      Logger.i("open-web-detail, url is: ".concat(url ?? "null"))
      if (url == null || url.length == 0) {
        Logger.e("open-web-detail, url is invalid.")
        return
      }
      this.webUrl = url
      this.pageStack.pushPath({ name: 'WebDetail' })
    })
  }

  build() {
    Navigation(this.pageStack) {

      // 主界面
      Column() {
        Tabs({
          barPosition: BarPosition.End
        }) {

          TabContent() {
            Artical({
              viewModel: this.viewModel
            })
          }
          .tabBar($r("app.string.artical_page_name"))

          TabContent() {
            Project({
              viewModel: this.viewModel
            })
          }
          .tabBar($r("app.string.project_page_name"))
        }
        .width("100%")
        .height("100%")
      }
      .width("100%")
      .height("100%")
    }
    .navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
    .hideToolBar(true)
    .hideTitleBar(true)
    .width("100%")
    .height("100%")
  }

}