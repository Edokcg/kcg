--Red-eyes Black Dragon Sword
local s,id=GetID()
function s.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCodeFun(c,CARD_REDEYES_B_DRAGON,282,1,true,true)
	
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)

    --Equip Limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(s.eqlimit)
	c:RegisterEffect(e1)

    --Atk Boost
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.value)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)	
end        
s.listed_names={CARD_REDEYES_B_DRAGON,282}
s.material_setcode={0x3b}

function s.filter(c)
	return c:IsFaceup() 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function s.eqlimit(e,c)
    return c:IsFaceup()
end
function s.value(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)*500+1000
end
function s.atkfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup()
end
function s.ffilter(c)
	return c:IsCode(170000153) and c:IsType(TYPE_SPELL)
end
