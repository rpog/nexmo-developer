NexmoRequestListener<CallMember> listener = new NexmoRequestListener<>() {
        @Override
        public void onError(NexmoApiError nexmoApiError) {
            //Handle error
        }

        @Override
        public void onSuccess(CallMember member) {
            //Handle success
        }
};

call.mute(ActionStatus.ON, listener);
