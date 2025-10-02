--混沌幻魔 阿米泰尔
local s, id = GetID()
function s.initial_effect(c)
	aux.god(c,1,id,0)

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(805)
    e0:SetValue(1)
    c:RegisterEffect(e0)
    
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,6007213,32491822,69890967)
	Fusion.AddContactProc(c,s.contactfil,s.contactop)

	--不会被战斗破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--攻击对方怪兽伤害阶段攻击提升
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10000044,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10000044,1))
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.cttg)
	e5:SetOperation(s.copyop)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10000044,2))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)	

	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_FIEND)
	c:RegisterEffect(e114)
	local e115=e114:Clone()
	e115:SetCode(EFFECT_ADD_ATTRIBUTE)
	e115:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e115)
end
s.listed_names={6007213,32491822,69890967}

function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
end
------------------------------------------------------------------------------
function s.atfilter(c,e)
	return 
	--not c:IsImmuneToEffect(e)
    not c:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET) and not c:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(s.atfilter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return tg:GetCount()>0 and c:IsAttackPos() end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,10000)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.atfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if #g<1 then return end
    -- Duel.Damage(1-tp,10000,REASON_BATTLE)
	local tc=g:GetFirst()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e3:SetValue(10000)
	c:RegisterEffect(e3)
	Duel.ForceAttack(c,tc)
end
------------------------------------------------------------------------------
function s.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end
------------------------------------------------------------------------------------------------------------------
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToChangeControler() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetControl(c,1-tp) then
		c:RegisterFlagEffect(100000441,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
		c:SetCardData(CARDDATA_PICCODE,60110982,EFFECT_FLAG_CANNOT_DISABLE,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,c)
	end
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100000441)~=0 end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.GetControl(e:GetHandler(),1-tp)
end