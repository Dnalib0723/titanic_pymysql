fetch('/passengers')
  .then(response => response.json())
  .then(data => {
    const list = document.getElementById('passenger-list');
    data.forEach(passenger => {
      const li = document.createElement('li');
      li.textContent = `Name: ${passenger.Name}, Age: ${passenger.Age}`;
      list.appendChild(li);
    });
  });
