call.addCallEventListener(new CallEventsListener() {

   //...

   @Override
   public void onCallStatusChanged(@NotNull CallStatusEvent event) { }
        event.getStatus() //CallStatusEvent.RINGING|CallStatusEvent.ANSWERED|...
});
