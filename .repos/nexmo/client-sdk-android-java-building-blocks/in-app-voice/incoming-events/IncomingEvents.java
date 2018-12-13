NexmoIncomingCallListener listener = new NexmoIncomingCallListener() {

    @Override
    public void onIncomingCall(NexmoCall nexmoCall) {
        //Handle incoming call
    }
};

NexmoClient.get().addIncomingCallListener(listener);
