import { ArticalDetail, ArticalTag } from "../model/ArticalData"
import { BannerData } from "../model/BannerData"
import { OPEN_WEB_DETAIL } from "../pages/Main"
import Logger from "../utils/Logger"
import MainViewModel from "../viewmodel/MainViewModel"
import { ListBottom } from "./ListBottom"

@Component
export struct Artical {

  @Prop
  viewModel: MainViewModel

  aboutToAppear(): void {
    // 启动则请求数据
    this.viewModel.fetchBannerData()
    this.viewModel.fetchArticalData(false)
  }

  build() {
    List() {
      // banner 部分
      ListItem() {
        Banner({
          bannerData: this.viewModel.bannerDatas
        })
      }

      // 文章内容
      LazyForEach(this.viewModel.articalDatas, (data: ArticalDetail, index: number) => {
        ListItem() {
          ArticleItem({
            articalDetail: data,
            index: index
          })
        }
      }, (item: ArticalDetail, index: number) => item.id?.toString() ?? index.toString())

      // 底部加载更多
      ListItem() {
        ListBottom({
          loadingState: this.viewModel.articalLoadingState,
          onErrorClick: () => {
            Logger.i("main-artical-list-bottom, error reload")
            this.viewModel.reloadArticalData()
          }
        })
      }
    }
    .width("100%")
    .height("100%")
    .onScrollIndex((start: number, end: number, center: number) => {
      // 不使用 onReachEnd 的原因是当 list 渲染到最后一个时就会进行回调，没有通过滑动的判断进行回调，回调时机不好控制
      const dataCount = this.viewModel.articalDatas.totalCount()
      if (end >= dataCount) {
        Logger.i(`main-artical-list, reach end and start to loadMore, end: ${end}, articalDatasCount: ${dataCount}`)
        this.viewModel.fetchArticalData(true)
      }
    })
  }

}

@Component
struct Banner {
  @Prop bannerData: BannerData[] = []

  build() {
    Column() {
      if (this.bannerDataValid()) {
        Swiper(){
          ForEach(this.bannerData, (data: BannerData) => {
            BannerItem({ bannerData: data })
          }, (item: BannerData, index: number) => item.id?.toString())
        }
        .indicator(false)
        .autoPlay(true)
        .loop(true)
        .onChange((index: number) => {

        })
        .width("100%")
        .height("100%")
      } else {
        // todo 轮播图遮罩
      }
    }
    .width("100%")
    .height(200)
  }

  bannerDataValid(): boolean {
    return this.bannerData.length > 0
  }

}

@Component
struct BannerItem {
  @Prop bannerData: BannerData

  build() {
    Stack({
      alignContent: Alignment.Bottom
    }) {
      Image(this.bannerData.imagePath)
        .width("100%")
        .height("100%")
      Text(this.bannerData.title)
        .fontSize(16)
        .fontColor($r("app.color.global_text"))
        .padding({ top: 2, bottom: 2 })
        .width("100%")
        .background($r("app.color.banner_text_background"))
    }
    .width("100%")
    .height("100%")
  }
}

@Component
struct ArticleItem {
  articalDetail: ArticalDetail = new ArticalDetail()
  index: number = 0

  private eventHub = this.getUIContext().getHostContext()?.eventHub
  
  build() {
    Column() {
      Row() {
        if (this.articalDetail.tags?.length ?? 0 > 0) {
          ArticalTags({ articalTags: this.articalDetail.tags })
            .padding({
              right: 6
            })
        }
        Text(
          (this.articalDetail.author?.length ?? 0 > 0) ? this.articalDetail.author : this.articalDetail.shareUser
        )
          .fontSize(14)
          .fontColor($r("app.color.second_text"))

        Blank() // 将日期占到行末

        Text(this.articalDetail.niceShareDate)
          .fontSize(15)
          .fontColor($r("app.color.second_text"))
      }
      .width("100%")
      .alignItems(VerticalAlign.Center)

      Text(this.articalDetail.title)
        .fontColor($r("app.color.global_text"))
        .fontSize(16)
        .width("100%")
        .padding({
          bottom: 6
        })

      Row() {
        Text(this.articalDetail.superChapterName + " / " + this.articalDetail.chapterName)
          .fontSize(15)
          .fontColor($r("app.color.second_text"))
      }
      .alignItems(VerticalAlign.Center)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: 12, right: 12, top: 6, bottom: 6
    })
    .width("100%")
    .onClick(() => {
      Logger.i("main-artical-detail-click, url is: ".concat(this.articalDetail.link ?? "null"))
      this.eventHub?.emit(OPEN_WEB_DETAIL, this.articalDetail.link)
    })
  }
}

@Component
struct ArticalTags {
  articalTags: ArticalTag[] = []

  build() {
    List({ space: 6 }){
      ForEach(this.articalTags, (tag: ArticalTag) => {
        ListItem() {
          Column() {
            Text(tag.name)
              .fontSize(14)
              .fontColor($r("app.color.artical_tag_color"))
              .padding({ left: 2, right: 2 })
          }
          .borderRadius(16)
          .borderColor($r("app.color.artical_tag_color"))
          .borderWidth(2)
        }
      }, (tag: ArticalTag, index: number) => tag.name)
    }
    .listDirection(Axis.Horizontal)
  }
}