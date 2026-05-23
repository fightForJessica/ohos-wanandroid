import { LoadingState } from "../model/mainpage/LoadingState"
import { ProjectTreeItemData } from "../model/mainpage/ProjectData"
import { MainViewModel } from "../viewmodel/MainViewModel"
import { LoadingView } from "./LoadingView"


@Component
export struct Project {

  @Prop
  viewModel: MainViewModel

  aboutToAppear(): void {
    this.viewModel.fetchProjectType()
  }

  build() {
    Column() {
      if (this.viewModel.projectTreeLoadingState == LoadingState.SUCCESS) {
        // tab 部分
        List() {
          LazyForEach((this.viewModel.projectTreeData), (item: ProjectTreeItemData, index: number) => {
            ProjectTreeItem({
              item: item,
              index: index,
              onItemClick: (item: ProjectTreeItemData, index: number) => {

              }
            })
          })
        }
        .width("100%")
        .height(50)
        .listDirection(Axis.Horizontal)
        .alignListItem(ListItemAlign.Center)
        .scrollBar(BarState.Auto)

        // 内容部分
        List() {

        }
        .width("100%")
        .height("100%")
      } else {
        LoadingView({
          loadingState: this.viewModel.projectTreeLoadingState,
          fontSize: 22,
          onErrorClick: () => {
            this.viewModel.fetchProjectType()
          }
        })
      }

    }
    .width("100%")
    .height("100%")
  }

}

@Component
struct ProjectTreeItem {

  @Prop
  item: ProjectTreeItemData = new ProjectTreeItemData()

  index: number = 0

  onItemClick?: (item: ProjectTreeItemData, index: number) => void

  build() {
    Text(this.item.name)
      .fontSize(16)
      .fontColor($r("app.color.global_text"))
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Center)
      .padding({
        left: 16, right: 16
      })
  }

}