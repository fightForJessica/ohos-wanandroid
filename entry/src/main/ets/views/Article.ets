import { ArticalDetail, ArticalTag } from "../model/ArticalData"
import { BannerData } from "../model/BannerData"
import MainViewModel from "../viewmodel/MainViewModel"

@Component
export struct Artical {

  @Prop
  viewModel: MainViewModel



  aboutToAppear(): void {
    this.viewModel.fetchBannerData()
    this.viewModel.fetchArticalData(false)
  }

  build() {
    List() {
      ListItem() {
        Banner({
          bannerData: this.viewModel.bannerDatas
        })
      }
      LazyForEach(this.viewModel.articalDatas, (data: ArticalDetail, index: number) => {
        ListItem() {
          ArticleItem({
            articalDetail: data,
            index: index
          })
        }
      })
    }
    .width("100%")
    .height("100%")
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
    Stack() {
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
    .alignContent(Alignment.Bottom)
    .width("100%")
    .height("100%")
  }
}

@Component
struct ArticleItem {
  articalDetail: ArticalDetail = new ArticalDetail();
  index: number = 0

  build() {
    Column() {
      Row() {
        if (this.articalDetail.tags?.length ?? 0 > 0) {
          ArticalTags({ articalTags: this.articalDetail.tags })
            .padding({
              right: 6
            })
        }
        Text(this.articalDetail.author)
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
