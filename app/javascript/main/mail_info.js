window.addEventListener('unhandledrejection', function(event) {
  // イベントオブジェクトは2つの特別なプロパティを持っています:
  alert(event.promise); // [object Promise] - エラーを生成した promise
  alert(event.reason); // Error: Whoops! - 未処理のエラーオブジェクト
});

window.addEventListener('turbolinks:load', () => {
  const loader = document.querySelector('.loader');
  const errorContainer = document.querySelector('.error-message-container');
  const emailInput = document.getElementById('user_email');
  const submitBtn = document.querySelector('#password_reset_actions');
  function removeErr() {
    const flashMsg = document.querySelector('.flash-message')
    if(flashMsg) {
      flashMsg.textContent = ''
    }
    const errorMsgTag = document.querySelector('.error-message')
    if(errorMsgTag && errorMsgTag.parentNode === errorContainer) {
      errorContainer.removeChild(errorMsgTag)
    }
  }
  submitBtn.addEventListener('click', async(event) => {
    loader.style.visibility = 'visible';
    removeErr();
    submitBtn.disable = true;
    event.preventDefault();
    const email = emailInput.value;
    try {
      const response = await fetch('/users/password', {
        method: 'Post',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ user: { email } } ),
      });
        
      if(response.ok) {
        loader.style.visibility = 'hidden';
        showPopup(email);
      } else {
        loader.style.visibility = 'hidden';
        const responseMsg = await response.text();
        const errorMessageMatch = responseMsg.match(/<span class="error-message">(.+)<\/span>/);
        if (errorMessageMatch) {
          loader.style.visibility = 'hidden';
          const errorMessageText = errorMessageMatch[1];
          const errorMessage = document.createElement('span');
          errorMessage.classList.add('error-message');
          errorMessage.textContent = errorMessageText;
          showError(errorMessage);
        } else {
          loader.style.visibility = 'hidden';
          console.error('エラーメッセージが見つかりません');
        }
      }
    } catch (error) {
      loader.style.visibility = 'hidden';
      console.error('エラーが発生しました', error);
    } finally {
      submitBtn.disabled = false;
    }
  })

  const popupMenu = document.querySelector('.password_reset.popup-menu');
  const overlay = document.querySelector('.overlay');

  function showPopup(email) {
    const message = `${email}にパスワード再設定のメールを送信しました`;
    const passwordResetHeader = document.querySelector('.password-reset__header');
    passwordResetHeader.insertAdjacentHTML('afterend', `<div class='password-reset_message'><span>${message}</span></div>`);
    popupMenu.style.display = 'block';
    overlay.style.display = 'block';
  }

  function showError(msg) {
    errorContainer.appendChild(msg);
  }

  document.addEventListener('turbolinks:before-visit', () => {
    removeErr();
  });

  // OKボタンクリックでログインページへ遷移
  const btn = document.querySelector('#password-reset__btn')
  btn.addEventListener('click', function(){
    window.location.href = '/users/sign_in';
    const message = document.querySelector('.password-reset__message')
    message.remove()
  })

});