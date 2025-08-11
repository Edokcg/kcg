--奥西里斯之神的制裁 （ZCG）
function c77240253.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e0:SetRange(LOCATION_DECK)
	e0:SetOperation(c77240253.moop)
	c:RegisterEffect(e0)

	--抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77240253.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77240253.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77240253.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77240253.distg12)
    c:RegisterEffect(e14)
end
function c77240253.filter(c)
  return c:IsSetCard(0xa70) or c:IsSetCard(0xa90)
end
function c77240253.refilter1(c)
  return c:IsSetCard(0xa70)
end
function c77240253.refilter2(c)
  return c:IsSetCard(0xa90)
end
function c77240253.moop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 then
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.BreakEffect()
	if Duel.GetMatchingGroupCount(c77240253.filter,tp,LOCATION_DECK,LOCATION_DECK,nil)>0 then
	   local g1=Duel.GetMatchingGroup(c77240253.refilter1,tp,LOCATION_DECK,LOCATION_DECK,nil)
	   local g2=Duel.GetMatchingGroup(c77240253.refilter2,tp,LOCATION_DECK,LOCATION_DECK,nil)
			 if  #g2==0 and Duel.Remove(g1+g2,POS_FACEUP,REASON_EFFECT)==#g1  then
			 Duel.BreakEffect()
				if Duel.GetLP(1-tp)>#g1*1000 then
				   Duel.Damage(1-tp,#g1*1000,REASON_EFFECT)
				   Duel.SetLP(1-tp,1)
				else
				   local lp=Duel.GetLP(1-tp)
				   Duel.Damage(1-tp,lp-1,REASON_EFFECT)
				   Duel.SetLP(1-tp,1)
				end
			elseif #g1==0 and Duel.Remove(g1+g2,POS_FACEUP,REASON_EFFECT)==#g2 then
			Duel.BreakEffect()
				if Duel.GetLP(1-tp)>#g2*1000 then
				   Duel.Damage(1-tp,#g2*1000,REASON_EFFECT)
				   Duel.SetLP(1-tp,1)
				else
				  local lp=Duel.GetLP(1-tp)
				  Duel.Damage(1-tp,lp-1,REASON_EFFECT)
				  Duel.SetLP(1-tp,1)
			   end
		   elseif #g1~=0 and #g2~=0 then
		   Duel.Win(tp,0x17)
			   end
			end
	end
end

function c77240253.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77240253.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240253.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end