document.addEventListener("DOMContentLoaded", function () {
    updateCartCount();
    loadCartItems();
});

let cart = JSON.parse(localStorage.getItem("cart")) || [];

function addToCart(foodId, foodName, price, image) {
    let existingItem = cart.find(item => item.foodId === foodId);
    
    if (existingItem) {
        existingItem.quantity += 1;
    } else {
        cart.push({ foodId, foodName, price, image, quantity: 1 });
    }
    
    localStorage.setItem("cart", JSON.stringify(cart));
    updateCartCount();
    loadCartItems();
}

function updateCartCount() {
    document.getElementById("cart-count").textContent = cart.reduce((sum, item) => sum + item.quantity, 0);
}

function loadCartItems() {
    let cartTable = document.getElementById("cart-items");
    cartTable.innerHTML = "";

    cart.forEach((item, index) => {
        cartTable.innerHTML += `
            <tr>
                <td><img src="${item.image}" width="50"></td>
                <td>${item.foodName}</td>
                <td>$${item.price}</td>
                <td>
                    <button class="btn btn-sm btn-secondary" onclick="changeQuantity(${index}, -1)">-</button>
                    ${item.quantity}
                    <button class="btn btn-sm btn-secondary" onclick="changeQuantity(${index}, 1)">+</button>
                </td>
                <td><button class="btn btn-sm btn-danger" onclick="removeItem(${index})">Remove</button></td>
            </tr>
        `;
    });
}

function changeQuantity(index, change) {
    cart[index].quantity += change;
    if (cart[index].quantity <= 0) cart.splice(index, 1);
    localStorage.setItem("cart", JSON.stringify(cart));
    updateCartCount();
    loadCartItems();
}

function removeItem(index) {
    cart.splice(index, 1);
    localStorage.setItem("cart", JSON.stringify(cart));
    updateCartCount();
    loadCartItems();
}

function clearCart() {
    localStorage.removeItem("cart");
    cart = [];
    updateCartCount();
    loadCartItems();
}
