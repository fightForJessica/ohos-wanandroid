import MainViewModel from '../viewmodel/MainViewModel'
import { Artical } from '../views/Article'
import { Project } from '../views/Project'

@Entry
@Component
struct Main {

  @State
  private viewModel: MainViewModel = new MainViewModel()

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End
      }) {

        // 首页
        TabContent() {
          Artical({
            viewModel: this.viewModel
          })
        }
        .tabBar($r("app.string.artical_page_name"))

        // 项目
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

}