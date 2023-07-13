document.addEventListener("turbolinks:load", function() {

  const sideImageBlock = document.querySelectorAll('.show-recruit__image.side-image');
  const leftArrow = document.querySelector('.left-arrow');
  const rightArrow = document.querySelector('.right-arrow');
  const slideCounter = 592;
  let currentTransform = 0;
  let currentImageNum = 1;
  let beforeImageNum;
  let image;

  rightArrow.addEventListener('click', () => {
    slideRight();
  });

  leftArrow.addEventListener('click', () => {
    slideLeft();
  });

  sideImageBlock.forEach((e, i) => {
    e.addEventListener('click', () => {
      beforeImageNum = currentImageNum;
      sideImageBlock[currentImageNum - 1].style.border = 'none';
      currentImageNum = i + 1
      currentTransform = slideCounter * i;
      arrowVisibility();
      if(beforeImageNum < currentImageNum) {
        for (let index = beforeImageNum; index !== currentImageNum; index++) {
          image = document.getElementById(`show-image-${index + 1}`)
          image.style.transform = `translateX(-${slideCounter * index}px)`;
        }
      } else {
        for (let index = currentImageNum; index !== beforeImageNum; index++) {
          image = document.getElementById(`show-image-${index + 1}`);
          image.style.transform = '';
        }
      }
      sideImageBlock[currentImageNum - 1].style.border = '1px solid';
    });
  });

  function slideRight() {
    image = document.getElementById(`show-image-${currentImageNum + 1}`)
    image.style.transform = `translateX(-${currentTransform + slideCounter}px)`;
    currentTransform += 592;
    currentImageNum += 1;
    sideImageBlock[currentImageNum - 2].style.border = 'none';
    sideImageBlock[currentImageNum - 1].style.border = '1px solid';
    arrowVisibility();
  }

  function slideLeft() {
    image = document.getElementById(`show-image-${currentImageNum}`)
    image.style.transform = '';
    currentTransform -= 592;
    currentImageNum -= 1
    sideImageBlock[currentImageNum].style.border = 'none';
    sideImageBlock[currentImageNum - 1].style.border = '1px solid';
    arrowVisibility();
  }

  function arrowVisibility() {
    leftArrow.style.visibility = 'visible';
    rightArrow.style.visibility = 'visible';
    if(currentImageNum == 1) {
      leftArrow.style.visibility = 'hidden';
    }
    else if(currentImageNum == 4) {
      rightArrow.style.visibility = 'hidden';
    }
  }

});