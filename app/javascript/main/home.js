document.addEventListener('turbolinks:load', function() {
  const userMenu = document.querySelector('.header__user-menu');
  const popupMenu = document.querySelector('.header-user-menu__wrapper');
  
  document.addEventListener('click', function(e) {
    let currentStyle = popupMenu.style.display;

    if(e.target == userMenu) {
      if(currentStyle == 'none') {
        popupMenu.style.display = '';
      } else {
        popupMenu.style.display = 'none';
      };
    } else {
      if(currentStyle == '') {
        popupMenu.style.display = 'none';
      };
    };
  });

  document.addEventListener('turbolinks:before-visit', function() {
    const popupMenu = document.querySelector('.header-user-menu__wrapper');
    popupMenu.style.display = 'none';
  });
});

document.addEventListener('turbolinks:load', function() {
  const clearBtn = document.querySelector('.search-clear-btn');
  clearBtn.addEventListener('click', function() {
    document.getElementById('keyword').value = '';
    document.getElementById('address').value = '';
    document.getElementById('name').value = '';
    document.getElementById('date').value = '';
    document.getElementById('meeting_time').value = '';
    document.getElementById('required_time').selectedIndex = 0;
    document.getElementById('start_age').selectedIndex = 0;
    document.getElementById('end_age').selectedIndex = 0;
    $('#user-evaluate__score').raty('cancel');
  })
});

