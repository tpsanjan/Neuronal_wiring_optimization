function [ box ] = pos2box( pos, x_width, y_width )
%POS2BOX Convert position to box.
    box = [1 + floor(pos(2) / y_width), 1 + floor(pos(1) / x_width)];
end