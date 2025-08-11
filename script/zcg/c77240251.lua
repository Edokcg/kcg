--奥西里斯之优胜劣汰 （ZCG）
function c77240251.initial_effect(c)
		  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	   --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240251,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c77240251.destg2)
	e3:SetOperation(c77240251.desop2)
	c:RegisterEffect(e3)

	--抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77240251.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77240251.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77240251.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77240251.distg12)
    c:RegisterEffect(e14)
end
function c77240251.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	globeRc=Duel.AnnounceRace(tp,1,RACE_ALL)
	--e:SetLabel(rc)
end
function c77240251.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_SZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCondition(c77240251.drcon)
	e1:SetTarget(c77240251.destg)
	e1:SetOperation(c77240251.desop)
	c:RegisterEffect(e1)
end
function c77240251.drcon(e,tp,eg,ep,ev,re,r,rp)
	--local race=e:GetLabel()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(tp) then
	e:SetLabelObject(d)
	return a:IsFaceup() and a:IsRelateToBattle() and d and d:IsRace(globeRc) and d:IsRelateToBattle()
	else
		e:SetLabelObject(a)
		return d and d:IsFaceup() and d:IsRelateToBattle() and a and a:IsRace(globeRc) and a:IsRelateToBattle()
	end
end
function c77240251.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk ==0 then return  (d~=nil and d:IsRelateToBattle() and d:GetControler(1-tp)) or 
	(a~=nil and a:IsRelateToBattle() and d:GetControler(1-tp)) end
	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c77240251.desop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if  d:IsRace(globeRc) and d:IsControler(1-tp) then
	  Duel.Destroy(d,REASON_EFFECT)
	else
	  Duel.Destroy(a,REASON_EFFECT)
	end
end

function c77240251.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77240251.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240251.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end