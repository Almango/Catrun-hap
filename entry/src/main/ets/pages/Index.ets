import {Mine} from "ets/pages/Mine";
import {Home} from "ets/pages/Home";


@Builder
export function IndexPageBuilder() {
  Index()
}

@Entry()
@Component
struct Index {
  @State CurrentTabIndex:number = 0;

  @Builder CustomTabBars(index: number, title: string, icon: Resource) {
    Column({space:5}) {
      Image(icon)
        .width(30)
        .height(30)
        .fillColor(this.CurrentTabIndex === index ? '#2c2c2c' : '#bfbfbf'  )
    }
  }
  build() {
    Column({space:20}){
      Tabs({barPosition: BarPosition.End}){
        TabContent(){

          Home()
        }.tabBar(this.CustomTabBars(0, '首页', $r('app.media.todo')))
        TabContent(){
          Column({space:24}){
            Image($r('app.media.null')).width(100).height(100).fillColor('#33826e70')
            Text('空空如也').fontSize(24).fontColor('#33826e70').fontWeight(FontWeight.Bold)
          }.width('100%').height('100%').justifyContent(FlexAlign.Center)
        }.tabBar(this.CustomTabBars(1, '消息', $r('app.media.note')))
        TabContent(){
          Mine()
        }.tabBar(this.CustomTabBars(2, '我的', $r('app.media.mine')))
      }
      // .animationDuration(0)
      .scrollable(false)
      .onChange((index: number) => {
        this.CurrentTabIndex = index;
        console.log(this.CurrentTabIndex.toString())
      })
    }.width('100%').height('100%').background('#f5efed')
  }
}