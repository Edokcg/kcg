--C/C 银翼之瞳 (KDIY)
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(511003050)
	c:RegisterEffect(e1)

    --Indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e3)

    --Immune
	-- local e4=Effect.CreateEffect(c)
	-- e4:SetType(EFFECT_TYPE_SINGLE)
	-- e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e4:SetRange(LOCATION_MZONE)
	-- e4:SetCode(EFFECT_IMMUNE_EFFECT)
	-- e4:SetValue(s.efilter)
	-- c:RegisterEffect(e4)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(68823957,1))
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(s.condition3)
	e11:SetOperation(s.operation3)
	c:RegisterEffect(e11)
end
s.listed_names={511003050}
s.listed_series = {0x902}

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return rp==1-tp and tc:IsSetCard(0x10ae)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
    local tg=re:GetTarget()
    local ae,atp,aeg,aep,aev,are,ar,arp=tc:CheckActivateEffect(false,true,true)
	if rp==tp then return end
    Duel.ClearTargetCard()
	local op=re:GetOperation()
    if tg then tg(ae,tp,aeg,aep,aev,are,ar,arp,1) end
	Duel.ChangeChainOperation(ev,function (ae,atp,aeg,aep,aev,are,ar,arp)
		op(ae,tp,aeg,aep,aev,are,ar,arp)
	end)
end