import consumer from "./consumer"

function chatCreate() {
  let currentUserId = document.getElementById('current_user_id').value;
  let roomId = document.querySelector('.chat-messages-container').getAttribute('data-room_id');
  const chatChannel = consumer.subscriptions.create(
    { 
    channel: "RoomChannel",
    room: `${currentUserId}_${roomId}`
    },
    {
    connected() {
      
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const msgWrap = document.querySelector('.chat-messages-wrap');
      const messageData = data['message'];
      msgWrap.insertAdjacentHTML('beforeend', messageData);
      if (data["isCurrent_user"] == false) {
        let newMessage = document.querySelector('.chat-messages-wrap').lastElementChild.querySelector('.text-wrap');
        newMessage.classList = 'text-wrap other_user';
      }
      scrollToBottom();
    },

    speak: function(content) {
      const partnerId = document.getElementById('partner_id').value;
      return this.perform('speak', { content: content, partner_id: partnerId, room_id: roomId });
    }
  });

  const button = document.querySelector('.chat-submit-btn');
  const chatInput = document.querySelector('.chat-input-field');

  function sendMessage() {
    const content = chatInput.value;
    chatChannel.speak(content);
    chatInput.value = '';
  };
  button.addEventListener('click', sendMessage);

  chatInput.addEventListener('keypress', function(event) {
    if (event.keyCode === 13) {
      sendMessage();
    }
  });
}

function scrollToBottom() {
  const chatMessagesWrap = document.querySelector('.chat-messages-wrap');
  chatMessagesWrap.scrollTop = chatMessagesWrap.scrollHeight;
};

document.addEventListener('turbolinks:load', function() {
  if(location.href.includes('/relations?target=')) {
    scrollToBottom();
    chatCreate();
  }
});