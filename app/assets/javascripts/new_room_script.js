  let idsList = [];  // ids 값을 저장할 배열
  let isNameAvailable = false; 
  let valid = [];
  let invalid = [];
  async function requestNew(){
      const formData = new FormData();
      const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
      idString = JSON.stringify(idsList);
      formData.append('authenticity_token', csrfToken);
      formData.append('room[name]', document.getElementById('name').value);
      if (idsList.length > 0) {
        formData.append('room[ids]', idString);
      }
      formData.append('room[password]', document.getElementById('password').value);
      formData.append('commit', 'Create Room');


      const response = await fetch('/rooms', {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': csrfToken, // 요청 헤더에 CSRF 토큰 추가,
          'Accept': 'application/json' // JSON 형식으로 응답을 요청
        }
      });

      const data = await response.json();
      return data.id;
  }
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
  async function signUpCheck(){
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const submitResult = document.getElementById('submitResult');
    try {
      const validationResult = await idsValidate();
      console.log(validationResult);
      valid = validationResult.valid;
      invalid = validationResult.invalid;

      const idsContainer = document.getElementById('idsContainer');
      renderIdsList();
      if(invalid.length != 0){
        submitResult.innerHTML = '백준 아이디를 확인 해주세요!'
        return false
      }
    } catch (error) {
      // 오류 처리
      console.error('Validation 오류:', error);
    }
    // 비밀번호와 비밀번호 확인이 일치하고 길이가 1글자 이상인 경우
    if(!isNameAvailable){
      submitResult.innerHTML = '중복체크를 하거나, 중복되지 않은 이름을 입력해주세요!';
      return false
    }else if(idsList.length == 0){
      submitResult.innerHTML = '적어도 한명의 id를 입력해주세요';
      return false
    }
    else if (password === confirmPassword && password.length >= 1) {
      submitResult.innerHTML = '사용 가능한 비밀번호입니다.';
      const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
      const id = await requestNew();
      window.location.href = `/rooms/${id}`;
    } else {
      submitResult.innerHTML = '비밀번호가 일치하지 않거나 너무 짧습니다.';
      return false
    }
  }
  function updateSignUpButtonState(isable) {
    const signUpButton = document.getElementById('signUpButton');
    signUpButton.disabled = isable; // signUpCheck의 반환값에 따라 버튼 활성화/비활성화
  }

  function checkDuplicate() {
    const name = document.getElementById('name').value;

    fetch('/room/duplicate?name=' + encodeURIComponent(name))
      .then(response => response.json())
      .then(data => {
        console.log(data);
        isNameAvailable = !data.exist
        const resultContainer = document.getElementById('resultContainer');
        resultContainer.innerHTML = data.exist ? '중복된 이름입니다.' : '사용 가능한 이름입니다.';
        updateSignUpButtonState(data.exist);
      })
      .catch(error => console.error('Error:', error));
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