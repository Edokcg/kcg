--青眼双头龙
function c77239674.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCodeRep(c,89631139,2,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77239674.splimit)
	c:RegisterEffect(e1)
end
function c77239674.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
