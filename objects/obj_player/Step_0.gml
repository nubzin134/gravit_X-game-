// --- Inversão de gravidade com a tecla X ---
if (keyboard_check_pressed(ord("X"))) {
    grav_invertida = !grav_invertida;
    grv *= -1;
}

// --- Controles (A e D para movimentação, VK_UP para pulo) ---
var key_left  = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_jump  = keyboard_check_pressed(vk_space);
var move = key_right - key_left != 0;

// --- Atualização vertical ---
vspd += grv;
vspd = clamp(vspd, vspd_min, vspd_max);

// --- Movimento horizontal ---
if (move) {
    move_dir = point_direction(0, 0, key_right - key_left, 0);
    move_spd = approach(move_spd, move_spd_max, acc);
} else {
    move_spd = approach(move_spd, 0, dcc);
}
hspd = lengthdir_x(move_spd, move_dir);

// --- Colisão Horizontal (pixel a pixel) ---
var sign_h = sign(hspd);
for (var i = 0; i < abs(hspd); i++) {
    if (!place_meeting(x + sign_h, y, obj_wall)) {
        x += sign_h;
    } else {
        hspd = 0;
        break;
    }
}

// --- Colisão Vertical (pixel a pixel) ---
var sign_v = sign(vspd);
for (var i = 0; i < abs(vspd); i++) {
    if (!place_meeting(x, y + sign_v, obj_wall)) {
        y += sign_v;
    } else {
        vspd = 0;
        break;
    }
}

// --- Detecção de chão ou teto com base na gravidade ---
var checando_superficie = grav_invertida ? y - 1 : y + 1;
var ground = place_meeting(x, checando_superficie, obj_wall);

if (ground) {
    coyote_time = coyote_time_max;
} else {
    coyote_time--;
}

// --- Pulo (respeitando a direção da gravidade) ---
if (key_jump && coyote_time > 0) {
    coyote_time = 0;
    vspd = 0;
    vspd += grav_invertida ? jump_height : -jump_height;
}

// --- Troca de sala quando o obj_lighit não existir ---
if (!instance_exists(obj_lighit)) {
    var proxima = room_next(room);
    if (proxima != -1) {
        room_goto(proxima);
    }
}

// --- Troca de sprite dependendo da gravidade e movimento ---
if (grav_invertida) {
    if (move) {
        sprite_index = spr_player_walk_X;
        image_speed = 0.2;
    } else {
        sprite_index = spr_player_idle_X;
        image_speed = 0;
    }
} else {
    if (move) {
        sprite_index = spr_player_walk;
        image_speed = 0.2;
    } else {
        sprite_index = spr_player_idle;
        image_speed = 0;
    }
}

