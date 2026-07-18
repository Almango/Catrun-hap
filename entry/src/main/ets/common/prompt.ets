export function Prompt(ctx:UIContext, content:string){
  ctx.getPromptAction().showToast({
    message: content
  });
}