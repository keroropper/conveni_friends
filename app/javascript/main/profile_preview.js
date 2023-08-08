import { checkFileSize } from "./recruit_preview";
document.addEventListener('turbolinks:load', function() {
  if(location.href.includes('/users')) {
    const inputImgField = document.getElementById('input-profile');
    let imgTag = document.querySelector('.profile-image>img');
    let deleteBtn = document.querySelector('.image-delete');
    let flag = true;
    if(deleteBtn) {
      addDeleteEvent(deleteBtn);
    }
    
    inputImgField.addEventListener('change', function(e) {
      preview(e.target)
    })

    function preview(target) {
      const file = target.files[0];
      // 5MB以上の画像アップロードを拒否
      if(checkFileSize(target.files, inputImgField)) {
        return;
      }
      
      const reader = new FileReader();

      reader.addEventListener("load", function (e) {
        let imgUrl = e.target.result;
        // 初期画像が無い場合
        if(!imgTag && flag) {
          createImgBlock(imgUrl);
          flag = false;
        // 初期画像がある場合
        } else {
          // 画像削除後、冒頭で定義したimgTagには削除前の画像が代入されているため、再度取得する
          let imgTag = document.querySelector('.profile-image>img');
          // 初期画像を削除せずに違う画像をアップする場合
          if(imgTag) {
            imgTag.src = imgUrl;
            switchIcon('hidden');
          // 初期画像を削除した後に画像をアップする場合
          }else {
            createImgBlock(imgUrl)
          }
        }
      });
      if(file) {
        reader.readAsDataURL(file);
      }
    }

    function createImgBlock(imgUrl) {
      // imgタグ作成
      const img = document.createElement("img");
      img.setAttribute("src", imgUrl);
      let imgBlock = document.querySelector('.profile-image');
      imgBlock.appendChild(img);
      // 削除ブロック作成
      let deleteBtn = document.createElement('div');
      deleteBtn.classList.add('image-delete');
      deleteBtn.textContent = '削除';
      const imgContainer = document.querySelector('.profile-photo-main-container');
      imgContainer.appendChild(deleteBtn);
      addDeleteEvent(deleteBtn);
      // アイコン非表示
      switchIcon('hidden');
    }

    function addDeleteEvent(target) {
      target.addEventListener('click', function(e) {
        let imgTag = document.querySelector('.profile-image>img');
        imgTag.remove();
        inputImgField.value = '';
        e.target.setAttribute('hidden', 'true');
        switchIcon('visible');
      })
    } 
    function switchIcon(style) {
      let icon = document.querySelectorAll('.profile-image>svg');
      let imageIcon = Array.from(icon);
      
      if(style == 'hidden'){
        imageIcon.forEach((e) => {
          e.setAttribute('style', 'visibility: hidden;');
        });
      }else if(style == 'visible'){
        imageIcon.forEach((e) => {
          e.removeAttribute('style', 'visibility: hidden;');
        });
      }
    }

    const updateBtn = document.getElementById("update-btn");
    const form = document.getElementById("user-update-form");

    updateBtn.addEventListener("click", function(event) {
      event.preventDefault();
      form.submit();
    });

  }

});