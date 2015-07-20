function r = direction(asimuth, elevation)
% Direction vector pointing to specified asimuth and elevation.
    r = [cos(elevation) .* cos(asimuth); cos(elevation) .* sin(asimuth); sin(elevation)];
end

