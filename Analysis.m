ChoiceLeft = SessionData.Custom.ChoiceLeft;
LeftHi = SessionData.Custom.LeftHi;
Subject = SessionData.Custom.Subject;
%%
figure;hold on;
plot(smooth(ChoiceLeft,10,'moving'));
plot(LeftHi);
title(Subject)