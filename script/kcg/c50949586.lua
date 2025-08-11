local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,s.ffilter,2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)

	--special summon rule
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e2:SetRange(LOCATION_EXTRA)
	--e2:SetCondition(s.sprcon)
	--e2:SetOperation(s.sprop)
	--c:RegisterEffect(e2)

	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.indtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
s.listed_series={0x900}
s.material_setcode={0x900}

function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(0x900,fc,sumtype,tp) and c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function s.indtg(e,c)
	return c:IsSetCard(0x900) and c~=e:GetHandler()
end
