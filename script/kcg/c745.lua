--闇黑死亡眼 (KA)
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,nil,SUMMON_TYPE_FUSION)
	c:EnableReviveLimit()

	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.drcon)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	
	--reveal
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(185,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.rvtg)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.listed_series={0x316}

function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_MZONE,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local chk=false
	eg:ForEach(function(c) 
		if c:IsSummonType(SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_FUSION) and c~=e:GetHandler() then chk=true end
	end)
	return chk and ep==tp
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

function s.rvtg(e,tp,ev,ep,ev,re,r,rp,chk)
	if chk==0 then
		local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
		if gdd:GetCount()<1 then return false end
		local gd=gdd:Filter(Card.IsFacedown,nil)
		return gd:GetCount()>0
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
	if gdd:GetCount()<1 then return end
	local gd=gdd:Filter(Card.IsFacedown,nil)
	if #gd>0 then Duel.ConfirmCards(tp, gd) end
end