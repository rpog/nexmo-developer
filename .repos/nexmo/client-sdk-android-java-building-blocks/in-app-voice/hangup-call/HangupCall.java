NexmoRequestListener<NexmoCall> listener = new NexmoRequestListener<>() {
        @Override
        public void onError(NexmoApiError nexmoApiError) {
            //Handle error
        }

        @Override
        public void onSuccess(NexmoCall call) {
            //Handle success
        }
};

call.hangup(listener);
