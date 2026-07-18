import {Request,FetchGroupList, AddGroupDialog, RemoveGroupFunction} from "ets/utils/group";
import {Prompt} from "ets/common/prompt";



export interface Group {
  id:number,
  title: string;
  color?: string;
  creation_date?:Date
}

@Entry()
@Component
struct Home {
  AddGroup_Prompt: CustomDialogController = new CustomDialogController({
    builder: AddGroupDialog({
      retrundata: (value: number) => {
        if (value === 200) {
          console.log('未响应')
          this.Refresh()
        }
      }
    }),
    alignment: DialogAlignment.Bottom,
    autoCancel: true,
    customStyle: true
  });

  @State message: string = 'Catrun';
  @State GroupList: Request[] = []
  @State Refreshing: boolean = false
  // 初始化 启动后自动加载代办
  aboutToAppear(): void {
    this.Refresh()
  }

  private async Refresh() {
    this.GroupList = await FetchGroupList()
  }
  @Builder buildRemoveButton(id:number) {
    Row() {
      Button('移除')
        .type(ButtonType.Normal)
        .fontColor(Color.Red)
        .backgroundColor('#fff')
        .height('100%')
        .width(80)
        .margin({left:10})
        .borderRadius(6)
        .onClick(async () => {
          const res = await RemoveGroupFunction(id)
          if (res.code === 200) {
            this.Refresh()
            Prompt(this.getUIContext(), res.message)
          }
        })
    }
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text(`代办组（${this.GroupList.length}）`)
          .fontSize(20)
          .fontColor('#524546')
      }
      .padding({ right:16, left:16 })
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.SpaceBetween)
      // .padding({ right:12, left:12 })

      Row(){
        Search({placeholder:'搜索代办组'}).borderRadius(6).backgroundColor('#fff').height(48)
          .placeholderColor('#ffc8c8c8')
      }.padding({ right:16, left:16 })


      // Line().width('100%').height(2).border({style:BorderStyle.Solid})

      Refresh({refreshing:$$this.Refreshing,builder:this.RefreshBuilder}){
        // 组列表
        List({space:12}) {
          ForEach(this.GroupList, (item: Group, index: number) => {
            ListItem() {
              Row({ space: 16 }) {
                Column({ space: 4 }) {
                  Text(item.title)
                    .fontSize(18)
                    .fontColor('#826e70')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Text(item.id?.toString())
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#999')
                Image($r('app.media.right')).width(18).fillColor('#80826e70')
              }
              .width('100%')
              .height(60)
              .padding({ right:16, left:16 })
              // .backgroundColor(item.color)
              .backgroundColor('#fff')
              .borderRadius(6)
              .justifyContent(FlexAlign.SpaceBetween)
              // .border({width:2, color:'#ffc8c8c8'})
            }.swipeAction({ end: this.buildRemoveButton(item.id) })  // 左滑移除代办
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Detail',
                params: item
              })
            })
          })
        }
        // .divider({ strokeWidth: 1, color: '#fff3f3f3' })
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Off)
      }.padding({ right:16, left:16 }).margin({top:4}).layoutWeight(1).onRefreshing(()=>{
        setTimeout(()=>{
          this.Refresh()
          this.Refreshing = false
        }, 1000)
      })

      Button(){
        Image($r('app.media.add')).width(24).fillColor('#826e70')
      }.width(50).height(50).borderRadius(50).fontSize(30).fontColor('#999').backgroundColor('#fff').position({bottom:20, right:20})
      .onClick(()=>{
        this.AddGroup_Prompt.open()
      })

      if (this.GroupList.length === 0){
        Column({space:24}){
          Image($r('app.media.null')).width(100).height(100).fillColor('#33826e70')
          Text('空空如也').fontSize(24).fontColor('#33826e70').fontWeight(FontWeight.Bold)
        }.width('100%').position({top:'40%'})
      }
    }
    .width('100%')
    .height('100%')

  }


  @Builder RefreshBuilder(){
    Column({space:12}){
      if (this.Refreshing){
        LoadingProgress().width(30).margin({bottom:20})
      }
    }

  }
}


export { Home };
