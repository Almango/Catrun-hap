import {Request, GetDetailFunction, ExchangeDetailFunction,RemoveDetailFunction, Response, AddDetailDialog} from 'ets/utils/detail';
import {Group} from "ets/pages/Home";
import { router } from '@kit.ArkUI';
import {Prompt} from "ets/common/prompt";

@Entry()
@ComponentV2
struct Detail {

  @Local information: Group = { id: 0, title: ''}
  @Local list:Request[] = []

  AddDetail_Prompt: CustomDialogController = new CustomDialogController({
    builder: AddDetailDialog({x:this.information.id,callback:()=>{this.Refresh()}}),
    alignment: DialogAlignment.Bottom,
    autoCancel: true,
    customStyle: true,
  });


  private async Refresh() {
    try {
      const data: Response = await GetDetailFunction(this.information.id)
      this.list = data.data ?? []
      console.log('list', JSON.stringify(this.list))
    } catch (error) {
      console.error('Refresh 失败：', error)
      this.list = []
    }
  }
  aboutToAppear(){
    this.information = router.getParams() as Group
    this.Refresh()
    // console.log('对象信息',JSON.stringify(this.information))

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
          const res = await RemoveDetailFunction(id)
          if (res.code === 200) {
            this.Refresh()
            Prompt(this.getUIContext(), res.message)
          }
        })
    }
  }

  build() {
    Column(){
      Column(){
        Row(){
          Text(this.information?.title).fontSize(26).fontColor('#fff').fontWeight(FontWeight.Bold).border({
            width: { bottom: 4 },
            color: '#fff',
            radius: { bottomLeft: 2, bottomRight: 2 }
          })

            .shadow({ radius: 6, color: '#00000080', offsetX: 2, offsetY: 2 })
        }.width('100%').height('60').padding({ right:16, left:16 })
      }
      List(){
        ListItemGroup({space:8}){
          ForEach(this.list.filter(item => item.status === 0), (item:Request, index:number)=>{
            ListItem(){
              Row({ space: 12 }) {
                Checkbox({ name: 'index', group: 'doing' }).width(20).shape(CheckBoxShape.ROUNDED_SQUARE).selectedColor(this.information.color)
                  .onChange(()=>{
                    ExchangeDetailFunction(item.id!, item.content!, item.status!)
                    this.Refresh()
                  })
                Text(item.content).fontSize(18).fontColor('#826e70')
                Text(item.gid?.toString()).fontSize(18).fontColor('#80826e70')
                Text(item.id?.toString()).fontSize(18).fontColor('#80826e70')
              }.width('100%').height(60).backgroundColor('#FFF').padding({ right:12, left:12 }).borderRadius(6)
            }.swipeAction({ end: this.buildRemoveButton(item.id) })
          })
        }.width('100%')

        ListItemGroup({space:8}){
          ListItem(){
            Row(){
              Text(`未完成（${this.list.filter(item => item.status === 1).length}）`).fontColor('#fff')
            }.width('100%').height(40)
          }
          ForEach(this.list.filter(item => item.status === 1), (item:Request, index:number)=>{
            ListItem(){
              Row({ space: 12 }) {
                Checkbox({ name: 'index', group: 'doing' }).width(20).shape(CheckBoxShape.ROUNDED_SQUARE).select(true).selectedColor(this.information.color)
                  .onChange(()=>{
                    ExchangeDetailFunction(item.id!, item.content!, item.status!)
                    this.Refresh()
                  })
                Text(item.content).fontSize(18).fontColor('#826e70').decoration({ type: TextDecorationType.LineThrough, color: "#999" })
                Text(item.gid?.toString()).fontSize(18).fontColor('#80826e70')
                Text(item.id?.toString()).fontSize(18).fontColor('#80826e70')
              }.width('100%').height(60).backgroundColor('#FFF').padding({ right:12, left:12 }).borderRadius(6)
            }.swipeAction({ end: this.buildRemoveButton(item.id) })  // 左滑移除代办
          })
        }.width('100%')
      }.padding({ right:16, left:16 }).margin({top:10})

      Button(){
        Image($r('app.media.add')).width(24).fillColor(this.information.color)
      }.width(50).height(50).borderRadius(50).fontSize(30).fontColor('#999').backgroundColor('#fff').position({bottom:20, right:20})
        .onClick(()=>{
          this.AddDetail_Prompt.open()
        })
    }.width('100%').height('100%').background(this.information.color)
  }
}




