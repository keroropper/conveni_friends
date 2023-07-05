document.addEventListener("turbolinks:load", () => {

  const fileField = document.querySelector('#img-file');
  let dataBox = new DataTransfer();

  fileField.addEventListener('change', (event) => {
          
    const files = event.target.files;
    // 5MB以上の画像アップロードを拒否
    if(checkFileSize(files, fileField)) {
      return;
    }
    
    const imageNum = document.querySelectorAll('.image').length
    const imageContainer = document.querySelector(`#crt-image-field-${imageNum + 1}`);
    const nextImageContainer = document.querySelector(`#crt-image-field-${imageNum + 2}`);
    const labelElement = imageContainer.querySelector('label');
    Array.from(files).forEach((file) => {
      const reader = new FileReader();
      //DataTransferオブジェクトに対して、fileを追加
      dataBox.items.add(file);
      //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に代入
      fileField.files = dataBox.files;

      reader.readAsDataURL(file);
      const place = document.querySelector(`#image-preview-${imageNum + 1}`)
      reader.addEventListener("load", function (event) {

        // プレビューブロック作成
        const imgBlock = document.createElement('div');
        imgBlock.className = 'prev-image-container';
        // imageを囲むdiv作成。（中央寄せに必要）
        const imgParent = document.createElement('div');
        imgParent.className = 'image'
        // imgタグ作成
        const img = document.createElement("img");
        img.setAttribute("src", event.target.result);
        // 削除ブロック作成
        const deleteBtn = document.createElement('div');
        deleteBtn.classList.add('image-delete');
        deleteBtn.textContent = '削除';
        // ブロックにimgと削除を追加し、画面に挿入
        imgParent.appendChild(img);
        imgBlock.appendChild(imgParent);
        place.appendChild(imgBlock);
        place.appendChild(deleteBtn);
        place.setAttribute('style', 'height: 100%;');
        imgBlock.setAttribute('style', 'height: 100%;');
        labelElement.setAttribute('style', 'visibility: hidden;');
        // 次のフィールドにラベルを表示
        if(imageNum < 3) {
          nextImageContainer.querySelector('label').removeAttribute('style', 'visibility: hidden;');
        };
        // 削除イベント追加
        addDeleteEvent(imgBlock, deleteBtn, fileField, files);
      });
    });
  });

  // 削除ボタンにイベント付与
  function addDeleteEvent(imgBlock, deleteBtn, fileField, files) {
    deleteBtn.addEventListener('click', () => {
      Array.from(files).forEach((file, i) => {
        dataBox.items.remove(file);
      });
      fileField.files = dataBox.files;

      // プレビュー削除
      imgBlock.remove();
      deleteBtn.remove();
      // 削除されたスペースに画像を詰める処理
      // 表示されている画像枚数
      const imgBlockCount = document.querySelectorAll('.prev-image-container').length;
      // 最初のフィールドの画像を取得
      const firstImg = document.querySelector("#image-preview-1").querySelector(".prev-image-container");
      // 画像が一枚のみに削除
      if(!imgBlockCount) {
        editStyle('1', '2');
        return
      // 1 2  の2を削除した場合
      } else if(imgBlockCount == 1 && firstImg) {
        editStyle('2', '3');
        return
      // 1 2 の1を削除 || 画像が3枚以上だった場合
      } else if((imgBlockCount == 1 && !firstImg) || (imgBlockCount >= 2)) {
        for(let i = 0; i < imgBlockCount; i++) {
          moveField(imgBlockCount, i);
        };
      };
    });
  };

  function checkFileSize(file, fileField) {
    const size_in_megabytes = file[0].size/1024/1024;
    if(size_in_megabytes > 5) {
      alert('ファイルサイズは最大5MBです。');
      fileField.value = '';
      return true
    };
  };

  function editStyle(first, second) {
    const firstField = document.querySelector(`#crt-image-field-${first} label`);
    const secondField = document.querySelector(`#crt-image-field-${second} label`);
    firstField.removeAttribute('style', 'visibility: hidden;');
    firstField.parentNode.querySelector('div').removeAttribute('style');
    secondField.setAttribute('style', 'visibility: hidden;');
  };

  function moveField(imgBlockCount, i) {
    // 前のフィールドが空で、後ろのフィールドに画像がある場合、前に詰める処理
    let before = document.querySelector(`#image-preview-${i + 1}`);
    let beforeBlock = before.querySelector(".prev-image-container");
    let next = document.querySelector(`#image-preview-${i + 2}`).querySelector(".prev-image-container");
    let nextDeleteBtn = document.querySelector(`#image-preview-${i + 2}`).querySelector(".image-delete");
    if(!beforeBlock && next) {
      before.appendChild(next);
      before.appendChild(nextDeleteBtn);
    };
    // 削除後、空白のフィールドにラベルを表示
    if(i === (imgBlockCount - 1)) {
      const removeField = document.querySelector(`#crt-image-field-${imgBlockCount + 1} label`);
      const nextRemoveField = document.querySelector(`#crt-image-field-${imgBlockCount + 2} label`);
      removeField.parentNode.querySelector('div').removeAttribute('style', 'height: 100%;');
      removeField.removeAttribute('style', 'visibility: hidden;');
      if(nextRemoveField){
        nextRemoveField.setAttribute('style', 'visibility: hidden;');
      };
    };
  };
      
});