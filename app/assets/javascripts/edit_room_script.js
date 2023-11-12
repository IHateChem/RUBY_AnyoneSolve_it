let idsList;
let valid = [];
let invalid = [];
document.addEventListener('DOMContentLoaded', function () {
    let roomDataElement = document.getElementById('room-data');
    if (roomDataElement) {
      idsList = JSON.parse(roomDataElement.dataset.ids) || [];
      // other code...
    }
  });

async function idsValidate(){
  const idsListString = JSON.stringify(idsList);
  uri = "/baekjoon/validate?ids=" + encodeURIComponent(idsListString)
  const response = await fetch(uri, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
    },
  });

  const data = await response.json();
  console.log('GET 요청 성공:', data);

  return {
    invalid: data.invalid,
    valid: data.valid
  };
}

async function edit(){
  if(idsList.length == 0){
    submitResult.innerHTML = '적어도 한명의 id를 입력해주세요';
    return false
  }
  const validationResult = await idsValidate();
  if(invalid.length != 0){
    submitResult.innerHTML = '백준 아이디를 확인 해주세요!'
    return false
  }
  const formData = new FormData();
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  idString = JSON.stringify(idsList);
  formData.append('authenticity_token', csrfToken);
  formData.append('room[name]', "<%= @room.name %>");
  if (idsList.length > 0) {
    formData.append('room[ids]', idString);
  }
  console.log(document.getElementById('password').value);
  formData.append('room[password]', document.getElementById('password').value);
  formData.append('commit', 'Update Room');
  const response = await fetch('/rooms/<%= @room.id %>', {
      method: 'PATCH',
      body: formData,
      headers: {
        'X-CSRF-Token': csrfToken, // 요청 헤더에 CSRF 토큰 추가,
        'Accept': 'application/json' // JSON 형식으로 응답을 요청
      }
    });

}
function addId() {
  const idsInput = document.getElementById('idsInput');
  const idValue = idsInput.value.trim();

  if (idValue.length > 0) {
    idsList.push(idValue);
    renderIdsList();
    idsInput.value = '';
  }
}

function removeId(index) {
  idsList.splice(index, 1);
  renderIdsList();
}


function renderIdsList() {
  const idsInput = document.getElementById('idsInput');
  const idsContainer = document.getElementById('idsContainer');

  // 기존 내용 비우기
  while (idsContainer.firstChild) {
    idsContainer.removeChild(idsContainer.firstChild);
  }

  // 새로운 내용 추가
  idsList.forEach((id, index) => {
    const idElement = document.createElement('div');
    idElement.textContent = `${id} `;

  
    if (valid && valid.includes(id)) {
      idElement.textContent += ' : O';
    }

    if (invalid && invalid.includes(id)) {
      idElement.textContent += ' : X';
    }

    const deleteButton = document.createElement('button');
    deleteButton.textContent = 'X';
    deleteButton.addEventListener('click', () => removeId(index));
    idElement.appendChild(deleteButton);
    idsContainer.appendChild(idElement);
  });
  }